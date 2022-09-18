module TurboHelper
  include TurboPower::StreamHelper
end

Turbo::Streams::TagBuilder.prepend(TurboHelper)
