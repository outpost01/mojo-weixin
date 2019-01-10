FROM ubuntu:latest
WORKDIR /root
USER root
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install -y \
	    make \
	    unzip \ 
	    wget \ 
	    tar \
	    perl \ 
	    perl-App-cpanminus \
	    perl-Compress-Raw-Zlib \
	    perl-IO-Compress-Gzip \
	    perl-Digest-MD5 \
	    perl-Digest-SHA \
	    perl-Time-Piece \
	    perl-Time-Seconds \
	    perl-Time-HiRes \
	    perl-IO-Socket-SSL \
	    perl-Encode-Locale \
	    perl-Term-ANSIColor && \
	    apt-get clean
RUN cpanm -vn Test::More IO::Socket::SSL Mojolicious
RUN wget -q https://github.com/sjdy521/Mojo-Weixin/archive/master.zip -OMojo-Weixin.zip \
    && unzip -qo Mojo-Weixin.zip \
    && cd Mojo-Weixin-master \
    && cpanm -v . \
    && cd .. \
    && rm -rf Mojo-Weixin-master Mojo-Weixin.zip
CMD perl -MMojo::Weixin -e 'Mojo::Weixin->new(log_encoding=>"utf8")->load(["ShowMsg"])->load("Mipush",data=>{registration_ids=>["$ENV{MOJO_WEIXIN_REG_ID}"]})->run'
