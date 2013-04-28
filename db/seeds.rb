admin = User.find_or_create_by_name('admin',
  email: 'admin@example.com',
  password: 'admin',
  password_confirmation: 'admin') { |u| u.activated = true }
admin_role = Role.find_or_create_by_name(name: 'admin')
admin.assignments.find_or_create_by_role_id(admin_role.id)
