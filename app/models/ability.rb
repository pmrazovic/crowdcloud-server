require 'account_role'
require 'human_intelligence_task_status'

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
    can [:edit, :update, :delete, :destroy, :publish, :confirm_publish], SensingTask, :account_id => @account.id
    can [:index, :show, :new, :create, :devices], HumanIntelligenceTask
    can [:edit, :update, :delete, :destroy, :publish, :confirm_publish, :finish_formulation], HumanIntelligenceTask, :account_id => @account.id
    can [:index, :show], Response
    hit_creation_step
  end

  private

  def hit_creation_step
    cannot [:step_1, :confirm_step_1, :finish_formulation], HumanIntelligenceTask, :status => [HumanIntelligenceTaskStatus::PENDING.name.to_s, 
                                                                                              HumanIntelligenceTaskStatus::PUBLISHED.name.to_s,
                                                                                              HumanIntelligenceTaskStatus::CLOSED.name.to_s]
    cannot [:step_2, :confirm_step_2], HumanIntelligenceTask, :status => [HumanIntelligenceTaskStatus::PENDING.name.to_s, 
                                                                         HumanIntelligenceTaskStatus::PUBLISHED.name.to_s,
                                                                         HumanIntelligenceTaskStatus::CLOSED.name.to_s]
    cannot [:step_3, :confirm_step_3], HumanIntelligenceTask, :status => [HumanIntelligenceTaskStatus::PENDING.name.to_s, 
                                                                         HumanIntelligenceTaskStatus::PUBLISHED.name.to_s,
                                                                         HumanIntelligenceTaskStatus::CLOSED.name.to_s,
                                                                         HumanIntelligenceTaskStatus::STEP_1.name.to_s]
    cannot [:step_4, :confirm_step_4], HumanIntelligenceTask, :status => [HumanIntelligenceTaskStatus::PENDING.name.to_s, 
                                                                         HumanIntelligenceTaskStatus::PUBLISHED.name.to_s,
                                                                         HumanIntelligenceTaskStatus::CLOSED.name.to_s,
                                                                         HumanIntelligenceTaskStatus::STEP_1.name.to_s,
                                                                         HumanIntelligenceTaskStatus::STEP_2.name.to_s]
    cannot [:edit, :update, :devices, :destroy, :publish, :confirm_publish], HumanIntelligenceTask, :status => [ HumanIntelligenceTaskStatus::STEP_1.name.to_s, 
                                                                                                                                 HumanIntelligenceTaskStatus::STEP_2.name.to_s,
                                                                                                                                 HumanIntelligenceTaskStatus::STEP_3.name.to_s]
  end

end
