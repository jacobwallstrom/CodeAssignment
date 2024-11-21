task :brew_install do
  sh "brew bundle install"
end

task :install => [:brew_install]

desc "Check for unused code"
task :periphery do
  sh "periphery scan --strict"
end

task :periphery_xcode do
  sh "periphery scan --skip-build --format xcode"
end

desc "Does a style check of the source code"
task :lint do
  touch "Build/commitHash.swift"
  sh "swiftlint --strict --quiet"
end
