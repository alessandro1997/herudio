# frozen_string_literal: true
ActiveAdmin.register Subscription do
  decorate_with SubscriptionDecorator

  config.sort_order = :lesson_id
  config.filters = false

  actions :index, :new, :create, :destroy

  menu false

  permit_params :user_id, :lesson_id, :origin

  index do
    selectable_column
    id_column

    column :user, sortable: :user_id
    column :course, sortable: :course_id
    column :lesson, sortable: :lesson_id
    column :created_at

    actions
  end

  form do |f|
    f.object.user = User.find_by(id: params[:user_id]) if params[:user_id]
    f.object.lesson = Lesson.find_by(id: params[:lesson_id]) if params[:lesson_id]
    f.object.origin = 'admin'

    f.inputs t('activeadmin.subscription.panels.details') do
      f.input :origin, as: :hidden
      f.input :user, collection: User.order(last_name: :asc)
      f.input :lesson, collection: Lesson.order(id: :asc)
    end

    f.actions
  end

  controller do
    def destroy
      destroy! notice: t('activeadmin.subscription.destroy.notice') do
        request.referer
      end
    end
  end
end
