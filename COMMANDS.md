### Upgrade Ruby
1. `ggpull` on `develop` or `master`
2. `ruby -v`
3. `rbenv install x.x.x`
4. `ruby -v`
5. If also upgrading `rbenv` / `bundler`, do that now: `gem install bundler`. You can install an older version with `gem install bundler -N -v "<2.0"`.
6. `gem install nokogiri -v '1.8.5' --source 'https://rubygems.org/'`
7. `bundle install` or if wanting to use an older version of `rbenv` then `bundle _1.17.3_ install`.
