require 'middleman-core'

::Middleman::Extensions.register(:extensionless_helper) do
  require 'middleman-extensionless-helper/extension'
  ::Middleman::ExtensionLessHelper
end
