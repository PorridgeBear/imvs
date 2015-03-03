//
//  Spline3D.swift
//  IMVS
//
//  Created by Allistair Crossley on 24/02/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import SceneKit

class Spline3D {
    
    var points: [SCNVector3] = []
    
    /**
     * Creates a new instance of SplineCurve3D
     * @param n num control points
     * @param t tension
     * @param r resolution
     */
    init(controlPoints: [SCNVector3], n: Int, t: Int, r: Int) {
        
        var knots = [Int](count: n + t + 1, repeatedValue: 0)
        generateKnots(&knots, n: n, t: t)
        
        var splineCurvePoints = [SCNVector3](count: r, repeatedValue: SCNVector3())
        generateCurve(controlPoints, n: n, knots: knots, t: t, splineCurvePoints: &splineCurvePoints, r: r)
        
        points = splineCurvePoints
    }
    
    /**
     * The positions of the subintervals of v and breakpoints, the position
     * on the curve are called knots. Breakpoints can be uniformly defined
     * by setting u[j] = j, a more useful series of breakpoints are defined
     * by the function below. This set of breakpoints localises changes to
     * the vicinity of the control point being modified.
     */
    func generateKnots(inout u: [Int], n: Int, t: Int) {

        for (var j = 0; j <= u.count - 1; j++) {
            if (j < t) {
                u[j] = 0
            } else if (j <= n) {
                u[j] = j - t + 1
            } else if (j > n) {
                u[j] = n - t + 2
            }
        }
    }
    
    /**
     * Create all the points along a spline curve
     *
     * @param   controlPoints       the control points (n of them)
     * @param   knots               the knots (of degree t)
     * @return  splineCurvePoints   the 3d points (r of them)
     */
    func generateCurve(controlPoints: [SCNVector3], n: Int, knots: [Int], t: Int, inout splineCurvePoints: [SCNVector3], r: Int) {
    
        var interval: Float = 0,
            increment: Float = Float((n - t + 2) / (r - 1))
        
        var i: Int = 0;
        for (i = 0; i < r - 1; i++) {
            splineCurvePoints[i] = getSplinePoint(knots, n: n, t: t, v: interval, controlPoints: controlPoints)
            interval += increment
        }
        
        splineCurvePoints[r - 1] = controlPoints[n]
    }
    
    /**
     * Creates a point on the curve
     *
     * @param   v   the position (range 0 to n - t + 2)
     * @return  p   the 3d point
     */
    func getSplinePoint(u: [Int], n: Int, t: Int, v: Float, controlPoints: [SCNVector3]) -> SCNVector3 {

        var p = SCNVector3()
        
        for (var k = 0; k <= n; k++) {
            
            let b = splineBlend(k, t: t, u: u, v: v);

            p.x += controlPoints[k].x * b;
            p.y += controlPoints[k].y * b;
            p.z += controlPoints[k].z * b;
        }
        
        return p;
    }
    
    /**
     * Recursively calculate the blending value
     * If the numerator and denominator are 0 the expression is 0.
     * If the deonimator is 0 the expression is 0
     */
    func splineBlend(k: Int, t: Int, u: [Int], v: Float) -> Float {

        var value: Float
        
        if t == 1 {
            if Float(u[k]) <= v && v < Float(u[k + 1]) {
                value = 1.0
            } else {
                value = 0.0
            }
        } else {
            if u[k + t - 1] == u[k] && u[k + t] == u[k + 1] {
                value = 0.0
            } else if u[k + t - 1] == u[k] {
                value = Float(u[k + t]) - v / Float(u[k + t] - u[k + 1]) * splineBlend(k + 1, t: t - 1, u: u, v: v)
            } else if u[k + t] == u[k + 1] {
                value = Float(v - Float(u[k])) / Float(u[k + t - 1] - u[k]) * splineBlend(k, t: t - 1, u: u, v: v);
            } else {
                value = Float(v - Float(u[k])) / Float(u[k + t - 1] - u[k]) * splineBlend(k, t: t - 1, u: u, v: v) +
                    Float(Float(u[k + t]) - v) / Float(u[k + t] - u[k + 1]) * splineBlend(k + 1, t: t - 1, u: u, v: v)
            }
        }
    
        return value
    }
    
    /**
     * Return the final 3d point set
     */
    func getPoints() -> [SCNVector3] {
        return points;
    }
}