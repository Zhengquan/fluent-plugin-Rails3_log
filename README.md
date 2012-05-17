fluent-plugin-Rails3_log
=========================

Fluent input plugin for Rails3 production.log


##How to use

Puts `in_Rails3_log.rb` to plugin directory.

```shell
% cp in_Rails3_log.rb path/to/fluent/plugin
```

Edit setting file.

```shell
% edit fluent.conf
```

```
<source>
  type Rails3_log
  path path/to/log/production.log
  tag rails3.log
</source>
```

##Expected record format

Sample

```
Started GET "/questions/7" for 127.0.0.1 at 2012-05-18 00:45:40 +0800
Processing by QuestionsController#show as JSON
  Parameters: {"id"=>"7"}
  ...
  ...
  Rendered questions/show.json.jbuilder (20.3ms)
Completed 200 OK in 38ms (Views: 25.2ms | ActiveRecord: 6.1ms | Sphinx: 0.0ms)
```

Then following JSON is going to be made.

```json
{
         "method" => "GET",
           "path" => "/questions/7",
     "ip_address" => "127.0.0.1",
    "access_time" => "2012-05-18 00:43:28 +0800",
     "controller" => "QuestionsController",
         "action" => "show",
           "mime" => "JSON",
    "status_code" => "200",
     "status_msg" => "OK",
      "proc_time" => "25",
     "views_time" => "16.9",
        "ar_time" => "2.7",
    "sphinx_time" => "0.0"
}
```
 