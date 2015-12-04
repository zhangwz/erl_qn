# erl_qn
Qiniu SDK for Erlang

没做的：

1、记录断点

2、分片上传（只是分4MB的块上传，考虑到服务端SDK用到这个模块的也不多，服务端带宽也比较好，就懒得分片了）

3、上传中校验crc32 以及 指定mimetype （纯粹是懒得写了，出问题的概率也比较小）

4、一些函数没对错误和异常做模式匹配（懒，出问题的概率比较小）

5、没有使用type spec来指定数据类型（懒）

6、没有写测试

PS：基本的东西都有了，另外什么校验putpolicy,上传重试，链接超时的设置也都有了


算是特色吧：

1、两种并行计算qetag的方法

2、奇怪的并行上传（分块）

3、强行使用自带的http client，结果写个表单上传都非常苦逼，要自己手写boundary，组织表单


有时间会优化的：

1、针对“没做的” 4 5 

2、代码修美观一点


USAGE：

1、 make

2、 upload有表单和分块上传

3、 utils里有些实用函数，如urlsafebase64encod qetag 

4、 pfop就是持久化处理了，音视频什么的

5、 bucket就是资源管理操作

6、 http里封装了get和post请求，另外包括重试和针对不同http status code给不同的结果，比如可能有问题的情况下，会多给一个reqid方便去查日志

PS: 别忘了inets:start().
