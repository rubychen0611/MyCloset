# MyCloset app大作业说明
### 陈紫琦 151220017
---

## APP功能概述
Mycloset是一款用于衣橱管理的APP，已实现的功能主要有向衣橱中添加衣物、获取实时天气、添加每日搭配、摇一摇随机推荐搭配、收藏搭配等。
## APP界面展示及基本实现原理介绍
app主要由分栏控制器控制的三个主界面衣橱、日历、搭配构成，下面依次进行介绍：

### 衣橱
####  1、分类界面
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/1.png)

由一个Table View和一个Collection View联动构成，主要实现原理是当用户选择Tableview中的某项时，同时控制Collecion view的跳转，而当用户滑动Collection View时，也需要控制Table View的选择情况。
####  2、衣橱界面
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/2.png)

由一个UICollectionViewController控制的Collection View构成，显示该子分类下的所有衣服的图片，点开可显示衣服的详情页面并修改。长按某一件衣服会出现提示框，点确定后可删除。
####  3、衣服详情页
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/3.png)

在添加衣服或修改衣服详情的时候显示，其中image view上添加了手势，点开会出现一个UIAlertSheet让用户选择是拍照还是从相册中获取图片，由UIImagePickerView的两种不同模式.camera和.photoLibrary分别实现，用户选择之后跳转至抠图页面进行抠图。分类选项按钮由一个两列的PikerView构成，显示衣服所在的大类和子类，其中需要控制左右的联动。买入时间由一个UIDatePicker实现。

衣服（Garment）作为一个数据模型实现了NSCoding协议，因此衣橱中的衣服可以持久化地存储在手机中。
####  4、抠图页面
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/4.png)

抠图页面的实现相对复杂，其中需要实现多个UIImage的扩展方法。首先要将用户选择的图片以合适的大小和比例显示在View中，因此向UIImage类中添加方法resizeImage，返回一个合适大小的图片，我设置的是将图片的宽度设为与UIScreen主屏幕大小一致，而高度按原比例进行缩放。

显示图片之后，用户通过手指滑动将衣服圈出来，出现一个由灰色虚线包围的选择框圈出所选部分，而其余部分颜色变暗，如果用户没有画一个完整的圈，则由直线自动连接起点和终点，确定后则回到衣服详情页。

其中手指滑动过程通过重写UIView的三个方法touchesBegan、touchesMoved、touchesEnded实现，每次滑动过程会产生一个滑动经过点（CGPoint类型）构成的数组，并即时调用setNeedsDisplay方法刷新界面。刷新界面会调用重写的UIView的draw方法，其中绘制了由当前滑动经过点连成的一条条线段。如果滑动结束，自动连成一个多边形，并且调用UIImage的另一个拓展方法toBeCut，将多边形裁剪，并绘制在屏幕上（由于要及时显示，此时返回的图片大小仍与原图相同），而底部背景图片的绘制调用另一个扩展方法alpha改变图片的透明度，结合黑色背景自然变暗。最终用户点确定后，还需将之前裁剪过的图片再调用一个拓展方法crop将边缘的空白裁减掉，只留一个紧紧包围图片的矩形，其中需要计算图片上下左右边缘的坐标。至此，图片可以合适大小显示在衣服详情页。
### 日历
#### 1、实时天气
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/9.png)

实时天气功能的实现需要先用CLLocalManager定位获得当前用户所在位置的经纬度（模拟器需要先设置定位在中国境内），然后向免费天气API心知天气请求数据获得实时天气。其中定位要求知道所在城市即可，所以精度设置为百米内。得到经纬度数据之后，在LocalManager的代理方法didUpdateLocations中利用OperationQueue新建一个线程通过网络通信请求天气数据，这样即使用户当前可能没有连接互联网，也不会阻塞UI，获取失败后通过异常处理机制在界面显示失败。解析天气数据时还需要熟悉JSON的形式和语法，才能正确地显示实时天气的图片、温度等数据。
####  2、日历控件
采用了第三方控件GCCalendar，主要实现了代理方法didSelectDate，当用户选择日期时，刷新上方搭配的ImageView。
#### 3、添加搭配界面
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/6.png)

添加搭配界面主要由一个继承了UIView类的BackGroundView类对象控制，当用户点击添加搭配的衣服，通过两个TableView界面和一个CollectionView界面选择衣服，然后BackGroundView中添加一个Subview，显示该衣服的图片，当选择某图片时，绘制该图片的边框，并将这张图片置于最上方。其中Subview是一个继承了UIImageView类的GarmentPhotoView对象，在其上添加了Pan和Pinch两种手势，使用户可以通过拖拽和捏合移动、放缩图片。点击界面下方的选择背景颜色按钮出现一个选择颜色的控件，也由一个第三方控件WDColorPickerView实现。删除按钮可以删除当前选中的衣服。最后当用户选择确定的时候，返回到日历界面，页面中央ImageView上会显示刚才BackGroundView的一个截图，截图功能由UIView的一个扩展方法实现。
####  4、摇一摇推荐搭配
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/7.png)
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/8.png)

点击摇一摇按钮，会出现类似微信摇一摇的黑色界面，用户摇动手机（模拟器可选择Hardware菜单中的Shake gesture模拟），动画和音效之后会显示添加搭配界面，但该界面上不是空白，而是随机的由用户一件上衣、一件下装、一双鞋组成的搭配，如不满意，用户可以在当前界面修改这个搭配或者返回摇一摇界面重新摇。

摇一摇功能的实现比较简单，只要在ViewController中重写motionBegan方法和motionEnded方法即可，开始摇动时通过动画效果控制两张图片分别上移和下移，再返回原处，同时用AVAudioPlayer播放音效。摇动结束后创建一个搭配界面的ViewController并在闭包中调用随机选择衣服的方法，创建三个GarmentPhotoView并由上自下显示在界面中央。如果用户还没有添加过鞋子等，便不显示。
###  搭配
 #### 1、查看收藏的搭配
 ![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/10.png)
 
由一个CollectionView构成，当用户在日历界面点击红心收藏当天的搭配，CollectionView中便多了一项以当天日期为名的截图。用户再次点红心可以删除搭配。

搭配（Match）和衣服一样，作为一个数据模型实现了NSCoding协议，因此每日搭配和收藏的搭配可以持久化地存储在手机中。
## 有待改进的问题
 - 抠图时采用的方法是用线段连接所有用户经过的点，效果并不是很连贯，有很多棱角，网上资料显示用贝塞尔曲线连接效果更好，但时间关系没有来得及实现。
 - 抠图时会显示灰色虚线边框，但该边框只是绘制在了UIView上，最初的设想是保留该边框进图片的话。但系统提供的边框只适合规则的图形如矩形、圆，如果想在不规则的UIImage上加边框比较复杂，可能需要针对像素处理，遂放弃。
 - 由于UICollectionView没有像tableview一样简单的编辑和删除方法，只能自己实现，尝试长按后在图片右上角出现一个删除按钮，但点击删除按钮需要添加tap手势来确定位置，添加之后tap手势的触发方法和删除按钮的触发方法的执行顺序不一定，出现有时候点删除无效的现象，暂未找到好的解决办法，只能用长按出现删除提示框代替。
 - 在github上找到很多很好的第三方控件，但试过各种方法cocoapods不知为何总是安装不上，只能放弃，采用将一些控件直接拖入工程的方法。

## 代码行数
![](https://github.com/rubychen0611/MyCloset/raw/master/MyCloset/screenshots/11.png)

除去第三方代码和空行，共2175行