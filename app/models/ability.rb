require 'account_role'

class Ability
  include CanCan::Ability

  def initialize(account)
    return unless account
    @account = account
    send(@account.role.underscore) if @account.role && !@account.confirmed_at.nil?
  end

  def administrator
    can :manage, :all
  end

  def crowdsourcer
    can :manage, Account, :account_id => @account.id
    can [:index, :show, :sensors, :responses, :statistics], Device
    can [:index, :show, :new, :create, :devices], OpenCall
    can [:edit, :update, :delete, :destroy, :publish, :confirm_publish], OpenCall, :account_id => @account.id
    can [:index, :show], Response
  end

end
