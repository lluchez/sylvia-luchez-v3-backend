# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Seed root folder
Folder.where(root: true).first_or_create(name: 'Home')

# Seed texts
ConfigurableText.where(code: 'biography').first_or_create(
  name: 'Biography',
  value: 'Biography goes here...',
  format: 'html_text'
)
ConfigurableText.where(code: 'statement').first_or_create(
  name: 'Statement',
  value: 'Art Statement goes here...',
  format: 'html_text'
)
