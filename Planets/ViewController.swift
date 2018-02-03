//
//  ViewController.swift
//  Planets
//
//  Created by Jacob Steves on 2018-01-30.
//  Copyright © 2018 Jacob Steves. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    /* When the view appears, we create the planet objects. The sun is unique and gets created first. Other planets are
     * created by making a call to the generatePlanetWithOrbit
     */
    override func viewDidAppear(_ animated: Bool) {
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun diffuse")
        sun.position = SCNVector3(0,0,-1)
        let sunRotator = Rotation(time: 8)
        sun.runAction(sunRotator)
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        
        let mercury = generatePlanetWithOrbit(root: nil, orbitRoot: SCNVector3(0,0,-1), rotation: 10, geometry: SCNSphere(radius: 0.02), diffuse: #imageLiteral(resourceName: "Mercury Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(1,0,0))
        let venus = generatePlanetWithOrbit(root: nil, orbitRoot: SCNVector3(0,0,-1), rotation: 15, geometry: SCNSphere(radius: 0.08), diffuse: #imageLiteral(resourceName: "Venus Surface"), specular: nil, emission: #imageLiteral(resourceName: "Venus Atmosphere"), normal: nil, position: SCNVector3(2,0,0))
        let earth = generatePlanetWithOrbit(root: nil, orbitRoot: SCNVector3(0,0,-1), rotation: 20, geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earth day"), specular: #imageLiteral(resourceName: "Earth Specular"), emission: #imageLiteral(resourceName: "Earth Emission"), normal: #imageLiteral(resourceName: "Earth Normal"), position: SCNVector3(3,0,0))
        let moon = generatePlanetWithOrbit(root: earth, orbitRoot: SCNVector3(3,0,0), rotation: 5, geometry: SCNSphere(radius: 0.05), diffuse: #imageLiteral(resourceName: "Moon Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))
        let mars = generatePlanetWithOrbit(root: nil, orbitRoot: SCNVector3(0,0,-1), rotation: 25, geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "Mars Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(6,0,0))
        let jupiter = generatePlanetWithOrbit(root: nil, orbitRoot: SCNVector3(0,0,-1), rotation: 40, geometry: SCNSphere(radius: 1), diffuse: #imageLiteral(resourceName: "Jupiter Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(14,0,0))
        let saturn = generatePlanetWithOrbit(root: nil, orbitRoot: SCNVector3(0,0,-1), rotation: 50, geometry: SCNSphere(radius: 0.8), diffuse: #imageLiteral(resourceName: "Saturn Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(15,0,0))
        let saturnRing = generatePlanetWithOrbit(root: saturn, orbitRoot: SCNVector3(0,0,0), rotation: 0, geometry: SCNTorus(ringRadius: 1.2, pipeRadius: 0.1), diffuse: #imageLiteral(resourceName: "Moon Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(15,0,0))
        let uranus = generatePlanetWithOrbit(root: nil, orbitRoot: SCNVector3(0,0,-1), rotation: 80, geometry: SCNSphere(radius: 0.5), diffuse: #imageLiteral(resourceName: "Uranus Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(18,0,0))
        let neptune = generatePlanetWithOrbit(root: nil, orbitRoot: SCNVector3(0,0,-1), rotation: 100, geometry: SCNSphere(radius: 0.45), diffuse: #imageLiteral(resourceName: "Neptune Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(20,0,0))
    }
    
    /* Create a planet and a planet parent and have the planet orbit the planet parent. This simulates the gravitational
     * orbit that the sun creates. As planets get farther from the sun, the gravitational pull is weaker, so the orbit is
     * slower. This approach lets us change the speed that the planet parent's children orbit, so as the planet gets
     * farther from the sun, we can just decrease this speed.
     *
     * @return SCNNode -    The planet parent. This is the object that lets the planet orbit. If creating a moon, you
     *                      want root to be the planet parent of the moon's planet. (eg, Earth is the moons planet
     *                      parent)
     */
    func generatePlanetWithOrbit(root: SCNNode?, orbitRoot: SCNVector3, rotation: TimeInterval, geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {

        let parent = SCNNode()
        parent.position = orbitRoot
        self.sceneView.scene.rootNode.addChildNode(parent)
        
        let newPlanet = planet(geometry: geometry, diffuse: diffuse, specular: specular, emission: emission, normal: normal, position: position)
        
        let planetRotation = Rotation(time: 8)
        let rootRotation = Rotation(time: rotation)
        
        newPlanet.runAction(planetRotation)
        parent.runAction(rootRotation)
        parent.addChildNode(newPlanet)
        root?.addChildNode(parent)
        
        return parent
    }
    
    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
    
    func Rotation(time: TimeInterval) -> SCNAction {
        let rotation = time != 0 ? 360.degreesToRadians : 0
        let rotator = SCNAction.rotateBy(x:0, y: CGFloat(rotation), z: 0, duration: time != 0 ? time : 1)
        let foreverRotator = SCNAction.repeatForever(rotator)
        return foreverRotator
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

