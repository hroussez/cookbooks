class PsgiSpec < MiniTest::Chef::Spec

  describe 'installs and runs psgi application as starman server' do

    it 'creates init script file' do
      file_path = "#{node[:psgi][:install][:dir]}/starman-psgi#{node[:psgi][:install][:extention]}"  
      file(file_path).must_exist
      file(file_path).must_have(:owner,"root")
      file(file_path).must_have(:group,"root")
      file(file_path).must_have(:mode,"755")

    end

    it 'CGI script returns 200 OK and Hello World' do
      result = assert_sh("sudo bash -c 'cd /tmp/psgi/starman && SERVER_PORT=80 SERVER_NAME=127.0.0.1 SCRIPT_NAME=/ REQUEST_METHOD=GET /usr/local/bin/plackup -s CGI app.psgi'")
      assert_includes result, 'Status: 200'
      assert_includes result, 'Hello World'
    end

    it 'runs server' do

      result = assert_sh('ps -u psgi-starman-user --no-headers | wc -l')
      assert_includes result, '3'

    end

    it 'application index page returns Hello World' do
      result = assert_sh("curl 127.0.0.1:5000")
      assert_includes result, 'Hello World'
    end

  end
end
