#!/bin/sh

mxmlc -source-path="../" -source-path="../../libs/" -keep-as3-metadata+=Theme,Savable -library-path+="../../libs/Degrafa_Beta3.swc" -library-path+="../../libs/as3base64/build/as3base64.swc" -library-path+="../../libs/map_flex_1_18.swc" -library-path+="../../libs/AlivePDF.swc" -library-path+="../../libs/flexlib.swc" -library-path+="../../libs/as3corelib.swc" -incremental=true -debug=true -output=test/collage_view.swf Main.mxml
cp test/collage_view.swf ~/Sites/dataengine/web/static/swf/
