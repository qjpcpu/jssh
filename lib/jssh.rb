require "jssh/version"
require 'jssh/string'

class Jssh
	attr_accessor :hosts,:user, :auth_cfg, :cmd, :printer
    
	def initialize
		@auth_cfg={}
        self.printer=:on
		@queue=Queue.new
	end
    def messages
        @queue
    end
    
	def go(from=0,len=nil)
		len||=self.hosts.size
        to=from+len-1
		password=self.auth_cfg[:password]
        keys=[self.auth_cfg[:key]].reject{|x| x.nil?}
		self.hosts[from..to].each_with_index do |host,i|
            result=""
			begin
			Net::SSH.start(host,self.user,:keys=>keys,:password=>password) do |ssh|
				result=ssh.exec!(self.cmd) || ''
			end
			rescue=>e
				result=e.to_s
			end
			yield host,result if block_given?
		end
	end
	def execute(from=0,len=nil,group_size=10)
        pr=start_printer(self)
		threads=[]
		len||=self.hosts.size
        to=from+len-1
		divider(self.hosts[from..to].size,group_size) do |df,dt|
			threads<<Thread.new(self,from+df,from+dt) do |rssh,f,t|
				rssh.go(f,t) do |h,r|
			        output=("="*20+h+"="*20).to_yellow+"\n"+r
                    rssh.messages.push output
                end
			end
		end	
        threads.each{|t| t.join}
        loop{ break if self.messages.size==0 } if  self.printer 
        Thread.kill pr
	end

	private
    def start_printer(jssh)
		Thread.new(jssh) do |rssh|
			while true
				puts rssh.messages.pop if rssh.printer
			end
		end
    end
	def divider(total,gsize)
		gcnt=total/gsize
		gcnt=gcnt+1 if total%gsize!=0
		gcnt.times do |i|
			from,len=i*gsize,gsize
			len=total%gsize if i==gcnt-1
			yield from,len
		end
	end
end
