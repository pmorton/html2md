Description
===========

A basic library that converts HTML to Markdown. It is basic in that it only supports basic HTML formatting (No CSS Support [yet])

Examples
========

require 'html2md'
require 'open-uri'

html2md = Html2Md.new(open("Http://www.google.com").read)
puts html2md.parse

``` markdown
GoogleSearch [Images](http://www.google.com/imghp?hl=en&tab=wi) [Videos](http://video.google.com/?hl=en&tab=wv) [Maps](http://maps.google.com/maps?hl=en&tab=wl) [News](http://news.google.com/nwshp?hl=en&tab=wn) [Shopping](http://www.google.com/shopping?hl=en&tab=wf) [Gmail](https://mail.google.com/mail/?tab=wm) [More »](http://www.google.com/intl/en/options/)[iGoogle](/url?sa=p&pref=ig&pval=3&q=http://www.google.com/ig%3Fhl%3Den%26source%3Diglk&usg=AFQjCNFA18XPfgb7dKnXfKz7x7g1GDH1tg) | [Web History](http://www.google.com/history/optout?hl=en) | [Settings](/preferences?hl=en) | [Sign in](https://accounts.google.com/ServiceLogin?hl=en&continue=http://www.google.com/)  
  
  
<table><tr><td> </td><td>  
</td><td>[Advanced search](/advanced_search?hl=en)[Language tools](/language_tools?hl=en)</td></tr></table>  
[Advertising Programs](/intl/en/ads/)[Business Solutions](/services/)[+Google](https://plus.google.com/116899029375914044550)[About Google](/intl/en/about.html)© 2012 - [Privacy](/intl/en/privacy.html)

 
```


Contributing
============
1. Fork this repository
2. Create a branch for your proposed changes
3. Add tests for your code
4. Make sure that all tests pass
5. Update Documentation!
6. Issue a pull request

License and Author
==================
Author:: Paul Morton (<geeksitk@gmail.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.