Pod::Spec.new do |s|
  s.name         = “FXTextField”
  s.version      = "1.0.0"
  s.summary      = "The package of useful tools, include categories and classes"
  s.license      = “GPL”
  s.authors      = { ‘Zeacone’ => ‘andreboot42@gmail.com'}
  s.platform     = :ios, “7.0”
  s.source       = { :git => "https://github.com/Zeacone/FXTextField.git", :tag => s.version }
  s.source_files = ‘Classes/**/*.{h,m}’
  s.requires_arc = true
end