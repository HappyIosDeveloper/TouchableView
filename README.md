# TouchableView
Make any UIView element tappable + Awesome press effect!

![hippo](https://github.com/HappyIosDeveloper/TouchableView/blob/main/preview.gif)

How to use:

Just copy & paste the TouchableView.swift class to your project & extend your view class from TouchableView.
This is enogh to make your view show the tapp effect.

to define an action to that view, simply do it like below:
        
        @IBOutlet weak var yourView: TouchableView!

        yourView.touchUpInside = {
            // Do your action here
        }

Cheers!
