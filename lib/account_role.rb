require 'enum'

class AccountRole < Enum
  AccountRole.add_item :ADMINISTRATOR, 'ADMINISTRATOR'
  AccountRole.add_item :CROWDSOURCER, 'CROWDSOURCER'
end