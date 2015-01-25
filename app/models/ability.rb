require 'account_role'
require 'hit_status'

class Ability
  include CanCan::Ability

  def initialize(account)
    return unless account
    @account = account
    send(@account.role.underscore) if @account.role && !@account.confirmed_at.nil?
  end

  def administrator
    can :manage, :all
    hit_creation_step
  end

  def crowdsourcer
    can :manage, Account, :account_id => @account.id
    can [:index, :show, :sensors, :responses, :statistics], Device
    can [:index, :show, :new, :create, :devices], SensingTask
    can [:edit, :update, :delete, :destroy, :publish, :confirm_publish], SensingTask, :crowdsourcer_id => @account.id, :crowdsourcer_type => 'Account'
    can [:index, :show, :new, :create, :devices], Hit
    can [:edit, :update, :delete, :destroy, :publish, :confirm_publish, :finish_formulation, :manage_hit_choices], Hit, :crowdsourcer_id => @account.id, :crowdsourcer_type => 'Account'
    can [:index, :show], Response
    hit_creation_step
  end

  private

  def hit_creation_step
    cannot [:step_1, :confirm_step_1, :finish_formulation], Hit, :status => [HitStatus::PENDING.name.to_s, 
                                                                                              HitStatus::PUBLISHED.name.to_s,
                                                                                              HitStatus::CLOSED.name.to_s]
    cannot [:step_2, :confirm_step_2], Hit, :status => [HitStatus::PENDING.name.to_s, 
                                                                         HitStatus::PUBLISHED.name.to_s,
                                                                         HitStatus::CLOSED.name.to_s]
    cannot [:step_3, :confirm_step_3], Hit, :status => [HitStatus::PENDING.name.to_s, 
                                                                         HitStatus::PUBLISHED.name.to_s,
                                                                         HitStatus::CLOSED.name.to_s,
                                                                         HitStatus::STEP_1.name.to_s]
    cannot [:step_4, :confirm_step_4], Hit, :status => [HitStatus::PENDING.name.to_s, 
                                                                         HitStatus::PUBLISHED.name.to_s,
                                                                         HitStatus::CLOSED.name.to_s,
                                                                         HitStatus::STEP_1.name.to_s,
                                                                         HitStatus::STEP_2.name.to_s]
    cannot [:edit, :update, :devices, :destroy, :publish, :confirm_publish, :manage_hit_choices], Hit, :status => [ HitStatus::STEP_1.name.to_s, 
                                                                                                                                 HitStatus::STEP_2.name.to_s,
                                                                                                                                 HitStatus::STEP_3.name.to_s]
  end

end
