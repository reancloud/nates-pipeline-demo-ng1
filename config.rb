##############################################################################################
# GENERAL CONFIGURATION
##############################################################################################

# A machine-readable name for your project.
#  - HCAP DevSecOps is able to derive other default settings from your project's name.
set :application, "nates-pipeline-demo-ng1"

# The project's application type
set :application_type, :pipeline

# Opt out of externalized configuration.
#  - HCAP DevSecOps supports a separate config repo to avoid the need for customer forks.
#  - A future version of HCAP DevSecOps will likely convert this feature to "opt in" only.
set :external_config_type, :none

# Specify the primary cloud provider being used.
#  - HCAP DevSecOps is able to configure various default capabilities based on this setting,
#    such as Terraform remote state.
set :cloud_provider, "aws"


##############################################################################################
# APPLICATION DEPLOYMENT
##############################################################################################

# *UNNEEDED:* Declare that you are using HCAP Deploy as the application deployment tool.
#  - HCAP DevSecOps defaults to using HCAP Deploy as a deployment tool.
#  - HCAP DevSecOps also supports "per sub-project" deployment tool selection.
set :app_deploy_tool, :reandeploy

# A list of machine-readable sub-project names.  Each one represents an application
# sub-project to be deployed, regardless of the deployment tool being used.
#  - HCAP DevSecOps is able to derive many other default settings from a sub-project name.
#  - When you select Terraform as your deployment tool, the default sub-project directory
#    will be `terraform/MY-SUBPROJECT-NAME`.
set :app_envs, [:myvpc, :mydb, :myapp]

# Define the HCAP Deploy environment ID for the application sub-project named :myvpc
#  - HCAP DevSecOps will automatically refer to this variable when deploying the sub-project
set :myvpc_reandeploy_id, 1
# Define the HCAP Deploy environment ID for the application sub-project named :mydb
#  - HCAP DevSecOps will automatically refer to this variable when deploying the sub-project
set :mydb_reandeploy_id, 2
# Define the HCAP Deploy environment ID for the application sub-project named :myapp
#  - HCAP DevSecOps will automatically refer to this variable when deploying the sub-project
set :myapp_reandeploy_id, 3

##############################################################################################
# INFRASTRUCTURE VALIDATION
##############################################################################################

# Opt in to using HCAP Test as the infrastructure validation tool.
#  - HCAP DevSecOps also supports "per sub-project" validation tool selection,
#    such as `set :NAME_infra_test_tool, :reantest`.
set :infra_test_tool, :reantest

# NOTE: Because you usually want different infrastructure per environment, the HCAP Test
# infrastructure test variables are defined in environment specific configuration files:
#  - config/dev.rb
#  - config/prod.rb


##############################################################################################
# SERVER VALIDATION
##############################################################################################

# Specify which server testing tool to use.
set :server_test_tool, :inspec

# What servers should be tested by inspec?
#  - HCAP DevSecOps supports a simple syntax for declaring servers to be tested.
#server :myserver,
#       protocol: "ssh",
#       host: "myserver",
#       user: "ec2-user",
#       keys: "target/ssh-keys/myserver-key.pem",
#       test_profile: "myserver"
#      ^^^
#      HCAP DevSecOps will automatically run the inspec profile
#      located in `test/MY-TEST-PROFILE`

# What if my server hostname, username or password is not known until run time?
#   - HCAP DevSecOps allows you to lazily load one of these values from HCAP Deploy
#     or Terraform outputs.  To do that, you can replace the _value_ in question
#     with something like one of the below examples:
#
#      # Read a Terraform output named 'myserver-hostname' from the 'app' layer named 'myapp'
#      terraform_output('app-myapp', 'myserver_hostname')
#
#      # Read an HCAP Deploy output named 'myserver-hostname' from the 'infra' layer named 'myinfra'
#      reandeploy_output('infra-myinfra', 'myserver_hostname')
#

# What if I don't even know how many servers I have until run time?
#   - HCAP DevSecOps allows you to lazily load a list of servers from many dynamic sources, such as
#     AWS auto scaling groups, Azure Scale Sets, AWS EC2 instance ID, Azure Virtual Machine ID.
#   - The general syntax for such an example is as below:
#
#      # Dynamically declare a list of servers to be tested based on an AWS autoscaling group
#      server_source 'my_ASG_name', 'aws', 'aws_autoscaling_group',
#               protocol:       'ssh',
#               port:           22,
#               user:           'ec2-user'
#               key:            'target/my-asg-key.pem',
#               test_profile:   'main_app'
#

# What inspec input attributes should be passed to the server tests?
#
#  - HCAP DevSecOps allows you to dynamically define the values of inspec attributes,
#    based on any logic that you can define using Ruby.
#  - HCAP DevSecOps allows you to "lazily" declare the values of inspec attributes,
#    so that they are not calculated until the exact time that they are needed.
#set :myserver_inspec_inputs do
#  {
#    'environment' => fetch(:pipeline_env),
#    'project' => fetch(:application),
#    'prefix' => "#{fetch(:pipeline_env)}-#{fetch(:application)}"
#  }
#end

##############################################################################################
# APPLICATION TESTING
##############################################################################################

# HCAP Test browser tests to be run, applied on top of default options.

# What websites should be tested by HCAP Test?
#  - HCAP DevSecOps supports a simple syntax for declaring websites to be tested by HCAP Test.
#  - HCAP DevSecOps will default to running all declared functional tests and load tests against
#    all declared websites, unless you specifically declare which tests to run against which websites.
website :mysite, protocol: :https, host: reandeploy_output('app-myapp.json','ec2_dns'), path: ""

# A list of HCAP Test functional tests to be run, with a minimal number of options required.
#  - HCAP DevSecOps automatically applies default test execution options to each test in the list below,
#    unless you specifically provide an alternative value.
#  - HCAP DevSecOps automatically loads Git credentials from the GIT_USER and GIT_PASS environment
#    variables, unless you specifically provide alternative values.
set :functional_tests, [
  {
    command_to_run_test: "mvn test -Dcucumber.options=\"--tags @app_test\"",
    git_repository_url: "",
    chrome: "72",
    firefox: "63"
  }
]

# A list of HCAP Test load tests to be run, with a minimal number of options required.
#  - HCAP DevSecOps automatically applies default test execution options to each test in the list below,
#    unless you specifically provide an alternative value.
#  - HCAP DevSecOps automatically loads Git credentials from the GIT_USER and GIT_PASS environment
#    variables, unless you specifically provide alternative values.
set :load_tests, [
  {
    command_to_run_test: "mvn test -Dcucumber.options=\"--tags @app_test\"",
    git_repository_url: "",
    chrome: "72",
    firefox: "63"
  }
]

# A list of HCAP Test security tests to be run, with a minimal number of options required.
#  - HCAP DevSecOps automatically applies default test execution options to each test in the list below,
#    unless you specifically provide an alternative value.
set :security_tests, [
  {
    username_field_xpath: "//input[@id='login']",
    password_field_xpath: "//input[@id='password']",
    submit_button_xpath: "//input[@id='submit']"
  }
]

##############################################################################################
# SMOKE TESTING
##############################################################################################

# Specify an URL testing tool.
#  - HCAP DevSecOps also supports "per website" URL test tool selection,
#    such as `set :WEBSITE_infra_test_tool, :reantest`.
set :url_test_tool, :inspec

# A list of URL tests to be run, with a minimal number of options required.
#  - HCAP DevSecOps automatically applies default test execution options to each test in the list below,
#    unless you specifically provide an alternative value.
#  - By default, HCAP DevSecOps will run each URL test against every website that you have declared
#    in your configuration.  Optionally, you can specify exactly which sites a test should run against
#    by specifying a sites: option, with an array of site names.
#
set :url_tests, [
  { url: "/logout" },
]
