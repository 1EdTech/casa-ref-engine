require 'pathname'
base_path = Pathname.new(__FILE__).parent.realpath
Dir.glob(base_path + "**/*.rb").reject(){ |path| path.match /^#{base_path + 'casa-engine/module/'}/ }.each(){ |r| require r }