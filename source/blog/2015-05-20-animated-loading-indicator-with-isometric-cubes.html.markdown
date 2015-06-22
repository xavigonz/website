---
title: Animated loading indicator with isometric cubes
date: 2015-05-20 14:10 CEST
author: Matthijs
---

In general people don't like to wait. And no matter how fast we make our application there will always be something that takes time to process. But in many cases, if the user is informed, they will be more patient.
Fortunately [LearningSpaces](http://learningspaces.io/) is pretty fast and there is little waiting time. But sometimes transitioning between pages can take a brief moment, ie. due to slow internet or a large request to the server.

So we can't prevent loading time but we can make it less boring. Show something awesome instead of a simple spinner or loading message. At least tickle the user's senses a bit while waiting. The first thing that came to mind was the __[isometric](http://en.wikipedia.org/wiki/Isometric)__ shape in our logo, consisting of a cube within a cube (or three times the letter "L" surrounding a cube). Perfect for our loading indicator:

![LearningSpaces logo](http://blog.learningspaces.io/content/images/2014/Nov/wireframe-2.png)

In this post I will explain and demonstrate how we recreated and animated our logo, and how to use it as a loading indicator in Ember.js.

### Isometric cubes

The biggest challenge is recreating our logo using HTML and CSS. There are several ways to accomplish this but we are using the CSS __[transform](https://developer.mozilla.org/en-US/docs/Web/CSS/transform)__ property to create the isometric faux-3D effect (sometimes refered to as 2.5D).

We need two cubes, but lets start with the first one. Create a container with three child elements for the visible cube faces (top, left and right):

```html
<div class="cube">
  <span class="face top"></span>
  <span class="face left"></span>
  <span class="face right"></span>
</div>
```

Now we add the styling. Give the faces a background color and make sure they are square. Next we apply the math to create the isometric effect using the `transform` property. This property can take a list of [transform functions](https://developer.mozilla.org/en-US/docs/Web/CSS/transform#CSS_transform_functions) but in the examples below we will only be using `rotate`, `skew`, `scale` and `translate`. Also note we use [transform-origin](https://developer.mozilla.org/en-US/docs/Web/CSS/transform-origin) which gives us control over the origin for the transformations. The CSS looks like this:

```css
.cube {
  position: absolute;
  top: 100px;
  left: 100px;
}

.face {
  transform-origin: 0 0;
  position: absolute;
  height: 100px;
  width: 100px;
}

.top {
  background: #f5f5f5;
  transform:
    rotate(210deg)
      skewX(-30deg)
      scaleY(0.864));
}

.left {
  background: #ccc;
  transform:
    rotate(90deg)
      skewX(-30deg)
      scaleY(0.864));
}

.right {
  background: #e0e0e0;
  transform:
    rotate(-30deg)
      skewX(-30deg)
      scaleY(0.864));
}
```

__Note:__ Don't forget to add vendor prefixes for the `transform*` properties if you want cross-browser [support](http://caniuse.com/#feat=transforms2d). In the demos I use [SCSS](http://sass-lang.com) and the [bourbon](http://bourbon.io) mixin library so I don't have to worry about these prefixes.

Check out the __[demo](http://codepen.io/snap/pen/NPqjMp?editors=110)__. I also created a demo of an __[alternative technique](http://codepen.io/snap/pen/GgJWmY?editors=110)__.
Both techniques are shown in the [demo](http://codepen.io/snap/pen/ogXwdz?editors=110) below.

<iframe height='430' scrolling='no' src='http://codepen.io/snap/embed/ogXwdz/?height=430' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/snap/pen/ogXwdz/'>ogXwdz</a> by Matthijs Kuiper (<a href='http://codepen.io/snap'>@snap</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

Now we need a second cube so we can recreate our logo. Duplicate the cube and wrap them in a container:

```html
<div class="logo">
  <div class="cube">
    <span></span>
    <span></span>
    <span></span>
  </div>
  <div class="cube">
    <span></span>
    <span></span>
    <span></span>
  </div>
</div>
```

Rotate the second cube 180 degrees and scale it to half its size:

```css
.cube:nth-child(2) {
  transform: rotate(180deg) scale(0.5);
}
```

Thats about it, see the [result](http://codepen.io/snap/pen/xbGLMY?editors=110) below. I also added some extra styling to render the cube as a wireframe like we have in our logo.

<iframe height='284' scrolling='no' src='http://codepen.io/snap/embed/xbGLMY/?height=284' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/snap/pen/xbGLMY/'>xbGLMY</a> by Matthijs Kuiper (<a href='http://codepen.io/snap'>@snap</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

### Animation please

To make the loading indicator complete we will add some animation. This can be done fairly easily with CSS by using __[@keyframes](https://developer.mozilla.org/en-US/docs/Web/CSS/@keyframes)__ and __[animation](https://developer.mozilla.org/en-US/docs/Web/CSS/animation)__. The `@keyframes` rule gives us control over the intermediate steps in an animation by defining keyframes (or waypoints). Each keyframe describes how the animated element should render at a given time during the animation sequence. The `animation` property lets you configure the timing and duration of the animation, as well as other details of how the animation sequence should progress.

For our loading indicator we want the cubes faces to shift between 3 colors by animating the background color. To do this we create an animation named "color-shift" and add 4 keyframes: start, finish and 2 in between:

```css
@keyframes color-shift {
  0%, 100% {
    background: #ccc;
  }
  33% {
    background: #e0e0e0;
  }
  66% {
    background: #f5f5f5;
  }
}
```

Now we can apply the animation to the cubes' faces. We configure the animation by setting its name (color-shift), duration (1.2s) and iteration count (infinite). But we don't want the cube's faces to get the same color on each keyframe. So we use `animation-delay` on the 2nd and 3rd face to delay the animation for these elements:

```css
.cube span {
  animation: color-shift 1.2s infinite;
}
.cube span:nth-child(2) {
  animation-delay: -0.8s;
}
.cube span:nth-child(3) {
  animation-delay: -0.4s;
}
```

__Note:__ Don't forget to add vendor prefixes for `@keyframes` and `animation*` if you want cross-browser [support](http://caniuse.com/#feat=css-animation).

Like the animations but think all the isometric projection math is too much fuzz? Don't worry, you can create the same effect with __inline SVG__. In fact, we are now using SVG for our loading indicator in LearningSpaces.

The [demo](http://codepen.io/snap/pen/MYwVeP?editors=110) below shows the HTML and the SVG aproach, both powered by the same CSS animation! The only difference with SVG is we have to animate the path's "fill" attribute instead of background color.

<iframe height='335' scrolling='no' src='http://codepen.io/snap/embed/MYwVeP/?height=335' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/snap/pen/MYwVeP/'>LearningSpaces logo with CSS (animated)</a> by Matthijs Kuiper (<a href='http://codepen.io/snap'>@snap</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

### Loading template in Ember.js

The only thing left to do was getting our loading indicator to show up between page transitions in [Ember.js](http://emberjs.com). Fortunately Ember provides [loading substates](http://emberjs.com/guides/routing/loading-and-error-substates/#toc_code-loading-code-substates) that allows you to do just that. Basicly the only thing we had to do is create a top-level template called `loading` and Ember takes care of the rest:

```html
<script type="text/x-handlebars" data-template-name="loading">
  <h1>Loading ...</h1>
</script>
```

It's as simple as that!

But like I said as the beginning of this post LearningSpaces is pretty fast, so we hardly get to see our loading indicator. [Hugo](http://blog.learningspaces.io/author/hugo/) wrote in his [post](http://blog.learningspaces.io/what-weve-been-making-the-past-weeks/):

> we find ourselves in the awkward position of complaining that our application isn't slow enough...

If you have any questions, contact us on [twitter](https://twitter.com/learningspaces)!
