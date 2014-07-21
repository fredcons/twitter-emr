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

 
command :start_cluster do |c|
  c.syntax = 'emr_driver launch, [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--name NAME', 'The name of your cluster'
  c.option '--instances_count INSTANCES_COUNT', Integer, 'The number of machines'
  c.option '--instances_type INSTANCES_TYPE', 'The instance type'
  c.action do |args, options|
    options.default :name => 'my-emr-cluster', :instances_count => 2, :instances_type => 'm1.small'
    response = emr.client.run_job_flow({
      :name => options.name,
      :log_uri => 's3://fredcons/emr_logs',
      :ami_version => '3.1.0',
      :instances => {
        :master_instance_type => options.instances_type,
        :slave_instance_type => options.instances_type,
        :instance_count => options.instances_count,
        :ec2_key_name => 'fc',
        :keep_job_flow_alive_when_no_steps => true,
        :termination_protected  => true
      }
    })
    puts "Job flow #{response[:job_flow_id]} has been created"

  end
end

command :stop_cluster do |c|
  c.syntax = 'emr_driver stop_cluster [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
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
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
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
  c.syntax = 'emr_driver list_clusters [options]'
  c.summary = ''
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
  c.example 'description', 'command example'
  c.option '--id ID', 'the cluster to use'
  c.action do |args, options|
    emr.job_flows[options.id].add_steps([
    {
      :name => 'install_hive',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => 's3://eu-west-1.elasticmapreduce/libs/script-runner/script-runner.jar',
        :args => ["s3://eu-west-1.elasticmapreduce/libs/hive/hive-script", 
                  "--base-path", 
                  "s3://eu-west-1.elasticmapreduce/libs/hive/", 
                  "--install-hive", 
                  "--hive-versions", 
                  "0.11.0.2"]        
      }
    }, 
    {
      :name => 'setup_hive',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => 's3://eu-west-1.elasticmapreduce/libs/script-runner/script-runner.jar',
        :args => ["s3://eu-west-1.elasticmapreduce/libs/hive/hive-script", 
                  "--base-path",
                  "s3://eu-west-1.elasticmapreduce/libs/hive/",
                  "--hive-versions", 
                  "0.11.0.2",
                  "--run-hive-script", 
                  "--args", 
                  "-f",
                  "s3://fredcons/fluentd/twitter/worldcup/definitions/hive_s3_config.q"]        
      }
    },
    {
      :name => 'create_hive_json_table',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => 's3://eu-west-1.elasticmapreduce/libs/script-runner/script-runner.jar',
        :args => ["s3://eu-west-1.elasticmapreduce/libs/hive/hive-script", 
                  "--base-path",
                  "s3://eu-west-1.elasticmapreduce/libs/hive/",
                  "--hive-versions", 
                  "0.11.0.2",
                  "--run-hive-script", 
                  "--args", 
                  "-f",
                  "s3://fredcons/fluentd/twitter/worldcup/definitions/twitter_json_schema.q"]        
      }
    },
    {
      :name => 'create_hive_flat_table',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => 's3://eu-west-1.elasticmapreduce/libs/script-runner/script-runner.jar',
        :args => ["s3://eu-west-1.elasticmapreduce/libs/hive/hive-script", 
                  "--base-path",
                  "s3://eu-west-1.elasticmapreduce/libs/hive/",
                  "--hive-versions", 
                  "0.11.0.2",
                  "--run-hive-script", 
                  "--args", 
                  "-f",
                  "s3://fredcons/fluentd/twitter/worldcup/definitions/twitter_flat_schema.q"]        
      }
    },
    #{
    #  :name => 'create_hive_json_partitions',
    #  :action_on_failure => 'TERMINATE_JOB_FLOW',
    #  :hadoop_jar_step => {
    #    :jar => 's3://eu-west-1.elasticmapreduce/libs/script-runner/script-runner.jar',
    #    :args => ["s3://eu-west-1.elasticmapreduce/libs/hive/hive-script",
    #              "--base-path",
    #              "s3://eu-west-1.elasticmapreduce/libs/hive/",
    #              "--hive-versions", 
    #              "0.11.0.2",
    #              "--run-hive-script", 
    #              "--args", 
    #              "-f",
    #              "s3://fredcons/fluentd/twitter/worldcup/definitions/partitions.q"]        
    #  }
    #},
    {
      :name => 'json_to_flat',
      :action_on_failure => 'TERMINATE_JOB_FLOW',
      :hadoop_jar_step => {
        :jar => 's3://eu-west-1.elasticmapreduce/libs/script-runner/script-runner.jar',
        :args => ["s3://eu-west-1.elasticmapreduce/libs/hive/hive-script", 
                  "--base-path",
                  "s3://eu-west-1.elasticmapreduce/libs/hive/",
                  "--hive-versions", 
                  "0.11.0.2",
                  "--run-hive-script", 
                  "--args", 
                  "-f",
                  "s3://fredcons/fluentd/twitter/worldcup/definitions/json_to_flat.q"]        
      }
    }
    ])
  end
end

#{:step_config=>{:name=>"Setup hive", :action_on_failure=>"TERMINATE_JOB_FLOW", :hadoop_jar_step=>{:properties=>[], :jar=>"s3://eu-west-1.elasticmapreduce/libs/script-runner/script-runner.jar", :args=>["s3://eu-west-1.elasticmapreduce/libs/hive/hive-script", "--base-path", "s3://eu-west-1.elasticmapreduce/libs/hive/", "--install-hive", "--hive-versions", "0.11.0.2"]}}, :execution_status_detail=>{:state=>"COMPLETED", :creation_date_time=>2014-07-19 21:45:52 +0200, :start_date_time=>2014-07-19 22:04:21 +0200, :end_date_time=>2014-07-19 22:04:31 +0200}}
