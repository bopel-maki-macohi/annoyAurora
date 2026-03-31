package;

import haxe.xml.Access;

class UpdateUtil
{
	static final httpLoc = 'https://raw.githubusercontent.com/bopel-maki-macohi/annoyAurora/refs/heads/main/Project.xml';

	public static var latestVersion:String = '';

	public static function checkForUpdate():Bool
	{
		#if hl
		latestVersion = Main.currentVersion;
		return false;
		#end

		var http = new haxe.Http(httpLoc);

		http.onData = function(data:String)
		{
			var root:Access = new Access(Xml.parse(data));

			for (rootElm in root.elements)
				if (rootElm.name == 'project')
					for (subElm in rootElm.elements)
						if (subElm.name == 'app')
						{
							if (latestVersion == '' || latestVersion == null)
								latestVersion = subElm.x.get('version');
						}

			trace('latestVer : $latestVersion');

			if (Main.currentVersion != latestVersion)
				return true;

			return false;
		}

		http.onError = function(error)
		{
			trace('error: $error');

			return false;
		}

		http.request();

		return false;
	}
}
