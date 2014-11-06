ActiveAdmin.register Course do
  decorate_with CourseDecorator

  filter :category
  filter :name
  filter :location

  permit_params :name, :description, :location, :seats, :category_id, organizer_ids: [], lessons_attributes: [
    :id, :starts_at_date, :starts_at_time_hour, :starts_at_time_minute, :ends_at_date, :ends_at_time_hour, :ends_at_time_minute, :_destroy
  ]

  action_item :subscriptions, only: :show do
    link_to t('activeadmin.course.actions.subscriptions'), admin_course_subscriptions_path(course)
  end

  index do
    selectable_column
    id_column

    column :name
    column :location
    column :category do |course|
      link_to course.category.name, admin_course_category_path(course.category)
    end

    actions
  end

  show do |course|
    panel t('activeadmin.course.panels.details') do
      attributes_table_for course do
        row :id
        row :name
        row :location

        row :category do |course|
          link_to course.category.name, admin_course_category_path(course.category)
        end

        row :seats

        row :organizers do
          course.organizers.map do |organizer|
            organizer.full_name
          end.join(', ')
        end

        row :description do
          course.description_html
        end
      end
    end

    panel t('activeadmin.course.panels.lessons') do
      table_for course.lessons do |lesson|
        column t('activerecord.attributes.lesson.id'), :id
        column t('activerecord.attributes.lesson.starts_at'), :starts_at
        column t('activerecord.attributes.lesson.ends_at'), :ends_at
        column t('activerecord.attributes.lesson.taken_seats'), :taken_seats
        column t('activerecord.attributes.lesson.available_seats'), :available_seats
      end
    end
  end

  form do |f|
    f.inputs t('activeadmin.course.panels.details') do
      f.input :category
      f.input :name
      f.input :description
      f.input :location
      f.input :seats
      f.input :organizers, as: :select, multiple: true, include_blank: true, collection: User.ordered_by_name.select(:id, :full_name)
    end

    f.has_many :lessons, heading: t('activeadmin.course.panels.lessons'), allow_destroy: true do |a|
      a.input :starts_at, as: :just_datetime_picker
      a.input :ends_at, as: :just_datetime_picker
    end

    f.actions
  end
end