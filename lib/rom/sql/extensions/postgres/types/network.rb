# frozen_string_literal: true

require "ipaddr"

module ROM
  module SQL
    module Postgres
      module Types
        IPAddress = Type("inet") do
          read = SQL::Types.Constructor(IPAddr) { |ip| IPAddr.new(ip.to_s) }

          SQL::Types.Constructor(::IPAddr, &:to_s).meta(read: read)
        end

        IPNetwork = Type("cidr") do
          read = SQL::Types.Constructor(IPAddr) do |ip|
            case ip
            when ::IPAddr
              ip
            when String
              ::IPAddr.new(ip)
            end
          end

          SQL::Types.Constructor(::IPAddr) { |ip| "#{ip}/#{ip.prefix}" }.meta(read: read)
        end
      end
    end
  end
end
