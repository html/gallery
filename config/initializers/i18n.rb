require 'i18n'
require 'russian'

module I18n
  public
  def self.handler(exception, locale, key, options)
    return key.to_s
    return exception.message if MissingTranslationData === exception
    raise exception
  end
end

I18n.exception_handler = :handler
