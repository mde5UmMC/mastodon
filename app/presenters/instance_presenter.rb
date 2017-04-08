# frozen_string_literal: true

class InstancePresenter
  delegate(
    :closed_registrations_message,
    :site_contact_email,
    :open_registrations,
    :site_title,
    :site_description,
    :site_extended_description,
    :site_terms,
    to: Setting
  )

  def contact_account
    Account.find_local(Setting.site_contact_username)
  end

  def user_count
    Rails.cache.fetch('user_count') { User.confirmed.count }
  end

  def status_count
    Rails.cache.fetch('local_status_count') { Account.local.sum(:statuses_count) }
  end

  def whitelist
    Rails.cache.fetch('whitelist') { DomainWhitelist.all }
  end

  def domain_count
    if DomainWhitelist.enabled? 
      whitelist.length
    else
      Rails.cache.fetch('distinct_domain_count') { Account.distinct.count(:domain) }
    end
  end

  def version_number
    Mastodon::Version
  end

  def source_url
    Mastodon::Version.source_url
  end

  def thumbnail
    @thumbnail ||= Rails.cache.fetch('site_uploads/thumbnail') { SiteUpload.find_by(var: 'thumbnail') }
  end
end
