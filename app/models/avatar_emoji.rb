# frozen_string_literal: true

class AvatarEmoji
  extend ActiveModel::Naming
  include ActiveModel::Serialization

  attr_reader :account, :shortcode

  Image = Struct.new(:source) do
    def url(type = :original)
      type = :original unless source.content_type == 'image/gif'
      source.url(type)
    end
  end

  def initialize(account, shortcode)
    @account = account
    @shortcode = shortcode
  end

  def image
    @image ||= Image.new(account.avatar)
  end

  def visible_in_picker
    false
  end

  def association(name)
    FakeAssociation.new()
  end

  def attributes
    {}
  end

  def inspect
    "#<AvatarEmoji shortcode: #{shortcode}, account_id: #{account.id}>"
  end

  SHORTCODE_RE_FRAGMENT = /@(([a-z0-9_]+)(?:@[a-z0-9\.\-]+[a-z0-9]+)?)/i

  SCAN_RE = /:#{SHORTCODE_RE_FRAGMENT}:/x

  class << self
    def from_text(text, domain = nil)
      return [] if text.blank?

      shortcodes = text.scan(SCAN_RE).map(&:first).uniq

      return [] if shortcodes.empty?

      emojis = shortcodes.reduce([]) do |emojis, shortcode|
        username, host = shortcode.split('@')
        account = Account.find_remote(username, host || domain)
        emojis << new(account, "@#{shortcode}") if !account.nil?
        emojis
      end

      emojis.compact
    end
  end

  class FakeAssociation
    def loaded?
      false
    end
  end
end
