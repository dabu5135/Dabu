# Touch관련
- 임의의 뷰를 터치하고 손가락의 움직임에 따라 이동시킴


``` objective-c

// touches가 시작될 때 호출되는 메소드
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // [touches anyObejct]는 아직 touches가 어떤 터치에 관한 것인지 
    // 구별하지 않았음. 이 예제에서는 무조건 터치만으로 사용할 것을 가정하였기 때문
    self.startPoint = [[touches anyObject] locationInView:self];
    
    // 이동시킬 때 해당뷰를 맨 앞으로 가져와야 이동시키면서 다른 뷰에 가려지지 않음
    [self.superview bringSubviewToFront:self];
}

// touches가 이동될 때 마다 호출되는 메소드
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 본래의 위치를 기억
    CGPoint movedPoint = [[touches anyObject] locationInView:self];
    NSLog(@"%.1f : %.1f", movedPoint.x, movedPoint.y);
    
    // 터치로 얼마만큼 이동했는지 float변수에 저장후
    float dx = movedPoint.x - _startPoint.x;
    float dy = movedPoint.y - _startPoint.y;
    
  	// 뷰의 센터를 변경!
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    // Set new location
    self.center = newcenter;
}

```