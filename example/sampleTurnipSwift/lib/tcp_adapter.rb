require "socket"


module ShumachTurnip
  module ConnectionAdapters
    class TCPAdapter
      attr_accessor :ip, :port, :sock

      def initialize ip, port
        @ip = ip
        @port =port 

        @sock = TCPSocket.open(ip, port)
      end

      def close
        @sock.close
      end

      def write msg
        msg = msg
        @sock.write msg 
      end

      def gets 
        @sock.gets
      end
 
      def read
        @sock.read
      end
      
    end
  end
end
