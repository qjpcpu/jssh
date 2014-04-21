require "jssh/version"
require "jssh/printer"
require 'jssh/string'

class Jssh
	attr_accessor :hosts,:user, :auth_cfg, :cmd, :printer
    
	def initialize
		@auth_cfg={}
        self.printer=PrinterController.new(StdoutPrinter.new)
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
			begin
			Net::SSH.start(host,self.user,:keys=>keys,:password=>password) do |ssh|
				result=ssh.exec!(self.cmd) || ''
				ssh.exec!(self.cmd) do |ch,stream,data|
                    data||=''
                    yield host,data,false if block_given?
                end
			end
			rescue=>e
                result=e.to_s
			end
            result||=''
            yield host,result,true  if block_given?
		end
	end
	def execute(from=0,len=nil,group_size=1)
        pr=start_printer(self)
		threads=[]
		len||=self.hosts.size
        to=from+len-1
		divider(self.hosts[from..to].size,group_size) do |df,dt|
			threads<<Thread.new(self,from+df,from+dt) do |rssh,f,t|
				rssh.go(f,t) do |h,r,over|
                    rssh.messages.push({'host'=>h,'content'=>r,'finished'=>over})
                end
			end
		end	
        threads.each{|t| t.join}
        loop{ break if self.printer.finished? }
        Thread.kill pr
	end

	private
    def start_printer(jssh)
        jssh.printer.submit_jobs(jssh.hosts)
		Thread.new(jssh) do |rssh|
            while true
			    data=rssh.messages.pop
				rssh.printer.print data['host'],data['content'],data['finished']
			end
		end
    end
	def divider(total,gsize)
		gcnt=total/gsize
		gcnt=gcnt+1 if total%gsize!=0
		gcnt.times do |i|
			from,len=i*gsize,gsize
			len=total%gsize if i==gcnt-1 && total%gsize!=0
			yield from,len
		end
	end
end
