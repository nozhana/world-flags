//
//  ViewController.swift
//  world-flags
//
//  Created by Nozhan Amiri on 4/23/22.
//

import UIKit

extension UIImage {
    /// Scales down a UIImage by `coefficient`
    ///
    /// This function is an extension of `UIImage`.
    ///
    /// Implementation
    /// ```swift
    /// resizedImage = image.scaledDown(by: 0.5)
    /// ```
    ///
    /// - Parameter coefficient: `CGFloat` by which the `UIImage` object is scaled down
    /// - Returns: A `UIImage?` optional containing the new resized image
    func scaledDown(by coefficient: CGFloat) -> UIImage? {
        guard coefficient >= 0 && coefficient <= 1 else {
            print("Coefficient must be a CGFloat in 0...1")
            return nil
        }
        
        let newWidth = size.width * coefficient
        let newHeight = size.height * coefficient
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class ViewController: UITableViewController {
    
    /// String array containing the name of countries to work with.
    ///
    /// Property of ``ViewController``
    ///
    /// Assigned in ``viewDidLoad()``
    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Countries", comment: "Countries")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
//        Add ...@3x.png files to countries and drop the text after country name "@3x.png"
        countries = items.filter{$0.hasSuffix("@3x.png")}.compactMap{$0.components(separatedBy: "@").first}
        
        print(countries) // MARK: Check if filenames are retrieved correctly
        
    }
    
    /// Determine number of rows displayed in `tableView`
    ///
    /// Overriding `tableView`
    /// - Parameters:
    ///   - tableView: tableView reference object. Usually `UITableView`.
    ///   - section: The section in which number of rows are being set.
    /// - Returns: The number of rows in the designated section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let country = countries[indexPath.row]
        
        content.text = NSLocalizedString(country, comment: "Country name")
        content.image = UIImage(named: country)?.scaledDown(by: 0.5)!
        
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        
        vc.selected = countries[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

