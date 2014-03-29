# Jssh

Jssh is a batch ssh tool, which OP would like.

## Installation

Add this line to your application's Gemfile:

    gem 'jssh'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jssh

## Usage

Simple Usage:

	$ jssh -f hosts -u jason -p jason -c 'hostname' --nopause
	====================172.16.39.139====================
	localcentos.vm
	====================192.168.42.136====================
	localcentos.vm
	Finished!
	
The hosts is a hosts file which lists every host per line like:

172.16.39.139

192.168.42.136

If you have configured the trusted relationship with each host, you can simply use:

	$ jssh -f hosts -u jason -c 'hostname' --nopause
	
Go further, if you place a file `~/.jsshrc`,and the content is:

	keyfile: /home/USER/.ssh/id_rsa
	user: jason
	
Then you can get more easier:

	$ jssh -f hosts -c 'hostname' --nopause
	
And, if you place multiple commands in a script such as `/path/to/script`, you can use like:

	$ jssh -f hosts -C /path/to/script --nopause
	
At last, I think this is very charming for OP, we can use a batch tool with pause. Just remove the `--nopause` option:

	$ jssh -f hosts -c 'hostname'
	
After the operation of the first host is done, the jssh can auto login to the first host, which lets us can check our operation is ok.

	====================172.16.39.139====================
	localcentos.vm
	Now the operations on the first host is completed, we're going to it for a check.
	Press ENTER to automatic to login 172.16.39.139 ...
	
	Last login: Sat Mar 29 00:57:07 2014 from 172.16.39.1
	jason@localcentos:~
	
After you finish check, `exit` back to jssh, we can choose to parallel or serial to finish the left operations, or just `Ctrl+C` to exit.

	Continue to finish all the left operations by parallel(p) or serial(s), [p/s] p
	====================192.168.42.136====================
	localcentos.vm
	Finished!
	
At last, type `jssh --help` for more help.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/jssh/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
