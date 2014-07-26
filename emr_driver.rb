#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'aws-sdk'
require 'inifile'
require 'terminal-table'

program :version, '0.0.1'
program :description, 'A commmand-line program to launch emr clusters'

@aws_config_file = IniFile.load(ENV['HOME']+ '/.aws/config')
AWS.config(
  :access_key_id => @aws_config_file['default']['aws_access_key_id'],
  :secret_access_key =>  @aws_config_file['default']['aws_secret_access_key'],
  :region => 'eu-west-1'
)

emr = AWS::EMR.new()

HIVE_VERSION = "0.11.0.2"
AMI_VERSION = "3.1.0"
SCRIPT_RUNNER_JAR = "s3://elasticmapreduce/libs/script-runner/script-runner.jar"
HIVE_SCRIPT = "s3://elasticmapreduce/libs/hive/hive-script"
HIVE_BASE_PATH = "s3://elasticmapreduce/libs/hive/"
PIG_SCRIPT = "s3://elasticmapreduce/libs/pig/pig-script"
PIG_BASE_PATH = "s3://elasticmapreduce/libs/pig/"
IMPALA_SCRIPT = "s3://elasticmapreduce/libs/impala/setup-impala"
IMPALA_BASE_PATH = "s3://elasticmapreduce/libs/impala/"
 
command :start_cluster do |c|
  c.syntax = 'emr_driver start_cluster [options]'
  c.summary = 'Starts a EMR cluster'
  c.description = ''
  c.example 'description', 'emr_driver start_cluster --with_hive --with_impala --instances_count 6 --name my_hive_impala_cluster'
  c.option '--name NAME', 'The name of your cluster'
  c.option '--instances_count INSTANCES_COUNT', Integer, 'The number of machines'
  c.option '--instances_type INSTANCES_TYPE', 'The instance type'
  c.option '--with_hive', 'To install hive'
  c.option '--with_pig', 'To install pig'
  c.option '--with_spark', 'To install spark'
  c.option '--with_impala', 'To install impala'
  c.action do |args, options|
    options.default :name => 'my-emr-cluster', :instances_count => 2, :instances_type => 'm1.medium'

    steps = []
    if options.with_pig
      steps << install_pig_step
    end
    if options.with_hive
      steps << install_hive_step
    end

    bootstrap_actions = []
    if options.with_spark
      bootstrap_actions << {:name => "spark_bootstrap_action", :script_bootstrap_action => {:path => "s3://elasticmapreduce/samples/spark/1.0.0/install-spark-shark.rb"}}
    end
    if options.with_impala
      bootstrap_actions << {:name => "impala_bootstrap_action", :script_bootstrap_action => {:path => "s3://elasticmapreduce/libs/impala/setup-impala", :args => ["--base-path", "s3://elasticmapreduce", "--impala-version", "1.2.4"]}}
    end

    response = emr.client.run_job_flow({
      :name => options.name,
      :log_uri => 's3://fredcons/emr_logs',
      :ami_version => AMI_VERSION,
      :instances => {
        :master_instance_type => options.instances_type,
        :slave_instance_type => options.instances_type,
        :instance_count => options.instances_count,
        :ec2_key_name => 'fc',
        :keep_job_flow_alive_when_no_steps => true,
        :termination_protected  => true
      },
      :steps => steps,
      :bootstrap_actions => bootstrap_actions
    })
    puts "Job flow #{response[:job_flow_id]} has been created"

  end
end

command :stop_cluster do |c|
  c.syntax = 'emr_driver stop_cluster [options]'
  c.summary = 'Stops a EMR cluster'
  c.description = ''
  c.example 'description', 'emr_driver stop_cluster --id xxx'
  c.option '--id ID', 'the cluster to stop'
  c.action do |args, options|
    job_flow = emr.job_flows[options.id] 
    puts "Job flow #{options.id} found, requesting termination"
    emr.client.set_termination_protection({
      :job_flow_ids => [options.id], 
      :termination_protected => false
    });
    job_flow.terminate    
  end
end

command :show_cluster do |c|
  c.syntax = 'emr_driver show_cluster [options]'
  c.summary = 'Shows the details of a given EMR cluster'
  c.description = ''
  c.example 'description', 'emr_driver show_cluster --id xxx'
  c.option '--id ID', 'the cluster to show'
  c.action do |args, options|
    job_flow = emr.job_flows[options.id] 
    rows = []
    rows <<  [job_flow.id, job_flow.name, job_flow.created_at, job_flow.ended_at, job_flow.state, job_flow.master_public_dns_name] 
    table = Terminal::Table.new :title => "Cluster", :headings => ['Id', 'Name', 'Created at', 'Ended at', 'State', "Master name"], :rows => rows
    puts table

    steps = []
    job_flow.step_details.each do |step_detail| 
      steps <<  [step_detail[:step_config][:name], 
                 step_detail[:execution_status_detail][:creation_date_time], 
                 step_detail[:execution_status_detail][:start_date_time], 
                 step_detail[:execution_status_detail][:end_date_time], 
                 step_detail[:execution_status_detail][:state]] 
    end  
    steps_table = Terminal::Table.new :title => "Steps", :headings => ['Name', 'Created at', 'Started at', 'Ended at', 'State'], :rows => steps
    puts steps_table

  end
end

command :list_clusters do |c|
  c.syntax = 'emr_driver list_clusters'
  c.summary = 'Lists all recent clusters'
  c.description = ''
  c.example 'description', 'command example'
  c.action do |args, options|
    puts "Listing active clusters..."
    rows = []
    #emr.job_flows.with_state('RUNNING', 'STARTING', 'BOOTSTRAPPING', 'SHUTTING_DOWN').each do |job_flow|
    emr.job_flows.each do |job_flow|
      rows << [job_flow.id, job_flow.name, job_flow.created_at, job_flow.ended_at, job_flow.state]
    end
    table = Terminal::Table.new :headings => ['Id', 'Name', 'Created at', 'Ended at', 'State'], :rows => rows
    puts table
  end
end

command :copy_json_to_flat do |c|
  c.syntax = 'emr_driver copy_json_to_flat [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'emr_driver copy_json_to_flat'
  c.option '--id ID', 'the cluster to use'
  c.action do |args, options|
    emr.job_flows[options.id].add_steps([
    {
      :name => 'create_hive_json_table',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => SCRIPT_RUNNER_JAR,
        :args => make_hive_args("s3://fredcons/fluentd/twitter/worldcup/definitions/twitter_json_schema.q")
      }
    },
    {
      :name => 'create_hive_flat_table',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => SCRIPT_RUNNER_JAR,
        :args => make_hive_args("s3://fredcons/fluentd/twitter/worldcup/definitions/twitter_flat_schema.q")
      }
    },
    {
      :name => 'json_to_flat',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => SCRIPT_RUNNER_JAR,
        :args => make_hive_args("s3://fredcons/fluentd/twitter/worldcup/definitions/json_to_flat.q")
      }
    }
    ])
  end
end

command :count_tweets_by_user_with_hive do |c|
  c.syntax = 'emr_driver count_tweets_by_user_with_hive [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'emr_driver count_tweets_by_user_with_hive'
  c.option '--id ID', 'the cluster to use'
  c.action do |args, options|
    emr.job_flows[options.id].add_steps([
    {
      :name => 'create_hive_flat_table',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => SCRIPT_RUNNER_JAR,
        :args => make_hive_args("s3://fredcons/fluentd/twitter/worldcup/definitions/twitter_flat_schema.q")
      }
    },
    {
      :name => 'hive_count_by_username',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => SCRIPT_RUNNER_JAR,
        :args => make_hive_args("s3://fredcons/fluentd/twitter/worldcup/definitions/hive_count_by_username.q")
      }
    }
    ])
  end
end


def make_hive_args(script_url)
  [HIVE_SCRIPT,
   "--base-path",
   HIVE_BASE_PATH,
   "--hive-versions",
   HIVE_VERSION,
   "--run-hive-script",
   "--args",
   "-f",
   script_url]
end

def make_impala_args(script_url)
  [IMPALA_SCRIPT,
   "--base-path",
   IMPALA_BASE_PATH,
   "--run-impala-script",
   "--impala-script",
   script_url]
end

def install_hive_step
  {
    :name => 'install_hive',
    :action_on_failure => 'TERMINATE_JOB_FLOW',
    :hadoop_jar_step => {
      :jar => SCRIPT_RUNNER_JAR,
      :args => [HIVE_SCRIPT,
                "--base-path",
                HIVE_BASE_PATH,
                "--install-hive",
                "--hive-versions",
                HIVE_VERSION]
    }
  }
end

def install_pig_step
  {
    :name => 'install_pig',
    :action_on_failure => 'TERMINATE_JOB_FLOW',
    :hadoop_jar_step => {
      :jar => SCRIPT_RUNNER_JAR,
      :args => [PIG_SCRIPT,
                "--base-path",
                PIG_BASE_PATH,
                "--install-pig"
               ]
    }
  }
end

def install_impala_step
  {
    :name => 'install_impala',
    :action_on_failure => 'TERMINATE_JOB_FLOW',
    :hadoop_jar_step => {
      :jar => SCRIPT_RUNNER_JAR,
      :args => [IMPALA_SCRIPT,
                "--base-path",
                IMPALA_BASE_PATH,
                "--install-impala"
               ]
    }
  }
end


#{:step_config=>{:name=>"Setup hive", :action_on_failure=>"TERMINATE_JOB_FLOW", :hadoop_jar_step=>{:properties=>[], :jar=>"s3://eu-west-1.elasticmapreduce/libs/script-runner/script-runner.jar", :args=>["s3://eu-west-1.elasticmapreduce/libs/hive/hive-script", "--base-path", "s3://eu-west-1.elasticmapreduce/libs/hive/", "--install-hive", "--hive-versions", "0.11.0.2"]}}, :execution_status_detail=>{:state=>"COMPLETED", :creation_date_time=>2014-07-19 21:45:52 +0200, :start_date_time=>2014-07-19 22:04:21 +0200, :end_date_time=>2014-07-19 22:04:31 +0200}}
