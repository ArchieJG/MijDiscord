# frozen_string_literal: true

module MijDiscord::Data
  class InviteChannel
    include IDObject

    attr_reader :name

    attr_reader :type

    def initialize(data, bot)
      @bot = bot

      @id = data['id'].to_i
      @name = data['name']
      @type = data['type']
    end

    def inspect
      MijDiscord.make_inspect(self, :id, :name, :type)
    end
  end

  class InviteServer
    include IDObject

    attr_reader :name

    attr_reader :splash_hash

    def initialize(data, bot)
      @bot = bot

      @id = data['id'].to_i
      @name = data['name']
      @splash_hash = data['splash_hash']
    end

    def inspect
      MijDiscord.make_inspect(self, :id, :name)
    end
  end

  class Invite
    attr_reader :channel

    attr_reader :server

    attr_reader :code

    attr_reader :max_uses
    alias_method :uses, :max_uses

    attr_reader :inviter
    alias_method :user, :inviter

    attr_reader :temporary
    alias_method :temporary?, :temporary

    attr_reader :revoked
    alias_method :revoked?, :revoked

    attr_reader :online_members

    attr_reader :total_members

    def initialize(data, bot)
      @bot = bot

      @channel = InviteChannel.new(data['channel'], bot)
      @server = InviteServer.new(data['guild'], bot)

      @code, @max_uses = data['code'], data['uses']
      @temporary, @revoked = data['temporary'], data['revoked']

      @online_members = data['approximate_presence_count']
      @total_members = data['approximate_member_count']

      @inviter = data['inviter'] ? @bot.cache.put_user(data['inviter']) : nil
    end

    def ==(other)
      @code == (other.respond_to?(:code) ? other.code : other)
    end

    alias_method :eql?, :==

    def delete(reason = nil)
      MijDiscord::Core::API::Invite.delete(@bot.auth, @code, reason)
    end

    alias_method :revoke, :delete

    def invite_url
      "https://discord.gg/#{@code}"
    end

    def inspect
      MijDiscord.make_inspect(self,
        :code, :channel, :server, :max_uses, :temporary, :revoked, :inviter)
    end
  end
end