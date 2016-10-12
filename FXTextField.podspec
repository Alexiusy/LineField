Pod::Spec.new do |s|
  s.name         = “FXTextField”
  s.version      = "1.0.0"
  s.summary      = "A subclass of UITextField which has some features as follow.

Supports moving cursor by pan gesture.
Supports floating label to show it's placeholder text.
To be continued."
  s.license      = “GPL”
  s.authors      = { ‘Zeacone’ => ‘andreboot42@gmail.com'}
  s.platform     = :ios, “7.0”
  s.source       = { :git => "https://github.com/Zeacone/FXTextField.git", :tag => s.version }
  s.source_files = ‘Classes/**/*.{h,m}’
  s.requires_arc = true
end