require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'fail2ban::filter' do

  let(:title) { 'fail2ban::filter' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress      => '10.42.42.42',
    }
  end

  describe 'Test filter define is called with no options' do
    let(:params) do
      {
        :filtername => 'sample1',
      }
    end
    let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
#
[INCLUDES]


[Definition]

failregex = 
ignoreregex = 

"
    end

    it { should contain_file('sample1.local').with_path('/etc/fail2ban/filter.d/sample1.local').with_content(expected) }
  end

   describe 'Test filter.local is created with all options' do
     let(:params) do
       {
         :filtername           => 'sample2',
         :filterfailregex      => ['first_fail_regex','second_fail_regex','complex[filter]'],
         :filterignoreregex    => 'now_ignore',
         :filterbefore         => 'add_before',
         :filterdefinitionvars => ['a = 1','b = 2', 'not c'],
       }
     end
     let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
#
[INCLUDES]

before = add_before
[Definition]

failregex = first_fail_regex
\tsecond_fail_regex
\tcomplex[filter]
ignoreregex = now_ignore

a = 1
b = 2
not c
"
     end

     it { should contain_file('sample2.local').with_path('/etc/fail2ban/filter.d/sample2.local').with_content(expected) }
     it { should contain_file('sample2.local').without_source }
   end

   describe 'Test filter define is called with a source file' do
    let(:params) do
      {
        :filtername   => 'sample3',
        :filtersource => 'puppet:///some/path/to/source',
      }
    end

    it { should contain_file('sample3.local').with_path('/etc/fail2ban/filter.d/sample3.local').with_source('puppet:///some/path/to/source') }
    it { should contain_file('sample3.local').with_content(nil) }
    it { should contain_file('sample3.local').without_template }
  end
end
