# Fix Checklist - AntennaPod UI Alignment

## Page 1: Home (Index.ets)
- [x] Missing info bar text "0 episodes · 0 minutes left" in toolbar area
- [x] Placeholder icons: Home uses ic_feed_black instead of proper home icon
- [x] Placeholder icons: Inbox uses ic_feed_black instead of proper inbox icon  
- [x] Placeholder icons: Search uses ic_feed_black instead of search icon
- [x] Placeholder icons: More/overflow uses ic_refresh_black instead of dots icon
- [x] Missing active tab indicator pill (Material3 rounded pill behind selected nav icon)
- [x] Label sizing: all tabs use 12vp instead of 11sp inactive / 14sp active distinction

## Page 2: Queue (QueuePage.ets)
- [x] Empty state not rendered properly (should show icon + "No queued episodes" + message)
- [x] Info bar "0 episodes • 0 minutes left" missing from rendered output
- [x] Placeholder icons: toolbar search → should be search icon
- [x] Placeholder icons: toolbar overflow → should be more/dots icon
- [x] Placeholder icons: nav Home → should be home icon
- [x] Placeholder icons: nav Inbox → should be inbox icon
- [x] Missing active tab indicator pill

## Page 3: Subscriptions (SubscriptionsPage.ets)
- [x] FAB "Add podcast" button not rendered properly
- [x] Empty state: icon missing, message missing, title wrong
- [x] Bottom nav: Subscriptions tab not showing selected/active state
- [x] Placeholder icons: search → should be search icon
- [x] Placeholder icons: overflow → should be dots icon
- [x] Nav background grey #EFEEEE vs white
- [x] Nav height 75vp vs 64vp target
