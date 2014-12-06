###
Overrides the default lineman-blog markdown settings. To see what the defaults
are, try running `lineman config markdown` or looking in:
  node_modules/lineman-blog/config/plugins/markdown.coffee
###
module.exports = (lineman) ->
  config:
    markdown:
      options:
        author: "Rudolf Hersén"
        title: "It Works On My Machine"
        description: "Rudolf Hersén's blog."
        url: "http://blog.hersen.name"
        dateFormat: 'YYYY-MM-DD'
        rssCount: 10 #<-- remove, comment, or set to zero to disable RSS generation
#        disqus: "rhersen" #<-- uncomment and set your disqus account name to enable disqus support
