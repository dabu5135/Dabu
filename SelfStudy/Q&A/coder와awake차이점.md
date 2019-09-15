# init(coder:)와 awakeFromNib()의 차이점

## Short Answer*

Your view controller and its view hierarchy are loaded from separate nib files at runtime.

Your view controller is loaded first and receives awakeFromNib when its nib is loaded, but its view hierarchy nib hasn't been loaded yet, so in awakeFromNib you shouldn't assume any outlets to the view hierarchy have been set yet.

Your view controller receives viewDidLoad after its view hierarchy nib has been loaded, so in viewDidLoad you can assume all outlets have been set.

## Long Answer

When Xcode builds your app, it compiles your storyboard. The result is a package (a folder that Finder treats as a file) containing an Info.plist and a bunch of .nib files. Example from one of my projects:

:; pwd
/Users/mayoff/Library/<snip>/Pinner.app/Base.lproj/Main.storyboardc
:; ll
total 80
drwxr-xr-x  10 mayoff  staff   340 May 11 22:13 ./
drwxr-xr-x   4 mayoff  staff   136 May 11 22:13 ../
-rw-r--r--   1 mayoff  staff  1700 May 11 22:13 AccountCollection.nib
-rw-r--r--   1 mayoff  staff  1110 May 11 22:13 AccountEditor.nib
-rw-r--r--   1 mayoff  staff  2999 May 11 22:13 BYZ-38-t0r-view-8bC-Xf-vdC.nib
-rw-r--r--   1 mayoff  staff   439 May 11 22:13 Info.plist
-rw-r--r--   1 mayoff  staff  7621 May 11 22:13 LqH-9K-CeF-view-OwT-Ts-HoG.nib
-rw-r--r--   1 mayoff  staff  6570 May 11 22:13 OZq-QF-pn5-view-xSR-gK-reL.nib
-rw-r--r--   1 mayoff  staff  2473 May 11 22:13 UINavigationController-ZKB-z3-xgf.nib
-rw-r--r--   1 mayoff  staff   847 May 11 22:13 UIPageViewController-ufv-JN-y6U.nib
The Info.plist maps the scene names in your storyboard to the corresponding nibs:

:; plutil -p Info.plist 
{
  "UIViewControllerIdentifiersToNibNames" => {
    "AccountCollection" => "AccountCollection"
    "UINavigationController-ZKB-z3-xgf" => "UINavigationController-ZKB-z3-xgf"
    "UIPageViewController-ufv-JN-y6U" => "UIPageViewController-ufv-JN-y6U"
    "AccountEditor" => "AccountEditor"
  }
  "UIStoryboardDesignatedEntryPointIdentifier" => "UINavigationController-ZKB-z3-xgf"
  "UIStoryboardVersion" => 1
}
A scene only shows up in this list if it has a storyboard ID, or a segue connects to it, or it is the initial scene.

The nib files list in Info.plist do not contain the view hierarchies of those view controllers. Each of those nib files contains the view controller of its scene and any other top-level objects in the scene, but not the view controller's view or any of its subviews.

A separate nib file contains the view hierarchy for the scene. The name of view hierarchy nib derived from the object IDs of the view controller and its top-level view. You can see the object ID of any object in your storyboard in the “Identity Inspector” in Xcode. For example, my “AccountCollection” scene's view controller's ID is BYZ-38-t0r and its view's ID is 8bC-Xf-vdC, so the view hierarchy for the scene is in file BYZ-38-t0r-view-8bC-Xf-vdC.nib. The scene nib file contains the name of its view hierarchy nib file:

:; strings - AccountCollection.nib |grep -e '-.*-'
UIPageViewController-ufv-JN-y6U
BYZ-38-t0r-view-8bC-Xf-vdC          <---------
UpstreamPlaceholder-5Hn-fK-fqQ
UpstreamPlaceholder-8GL-mk-Rao
q1g-aL-SLo.title
If a scene doesn't have a view hierarchy, then there will just be a nib file for the view controller and no separate nib file for the view hierarchy. For example, a UIPageViewController scene doesn't have a view hierarchy in the storyboard so there's no view hierarchy nib corresponding to UIPageViewController-ufv-JN-y6U.nib.

So what does all this have to do with your question? Here's what: when your app loads a scene from the “storyboard”, it's loading the nib file containing the view controller (and other top-level objects). When the nib loader finishes loading that nib file, it sends awakeFromNib to all the objects it just loaded. This includes your view controller, but it does not include your views, because your views weren't in that nib file.

Later, when your view controller is asked for its view property, it loads the nib file containing its view hierarchy. The view controller passes to -[UINib instantiateWithOwner:options:] as the owner argument. This is how the nib loader can connect objects in the view hierarchy to the view controller's outlets and actions.

When the nib loader finishes loading the view hierarchy nib, it sends awakeFromNib to all the objects it just loaded. Since your view controller was not one of those objects, your view controller does not receive an awakeFromNib message at this time.

When instantiateWithOwner:options: returns, the view controller sends itself the viewDidLoad message. This is your opportunity to make changes to the view hierarchy.