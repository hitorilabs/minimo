# Overview

It feels terrible trying to work with ARKit without any
understanding of Swift or IOS development. I've tried my
best to reduce the code down to something that should be
much easier to understand.

- Simple Python UDP Server that listens for UDP packets
- Basic IOS app that sends ARFaceTracking data as JSON

# Instructions

Assumes you have an IPhone with FaceID

In general, it seems like vtubers have converged on
Apple's proprietary ARKit software to get accurate face
tracking and body motions.

- Build/Sideload IOS app onto your IPhone (requires NSLocalNetworkUsageDescription + NSCameraUsageDescription)
- Run `server.py` (best to point `IP_ADDRESS` at your local machine, `PORT` is default 25565)
- Start IOS app and enter matching `IP_ADDRESS`