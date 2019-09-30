;; -*- mode: scheme; -*-
;; Farm Crap App Pro Copyright (C) 2016 FoAM Kernow
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.
;;
;; You should have received a copy of the GNU Affero General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define i18n-text
  (list

   (list 'title (list "The Farm Crap App: Pro Edition"))
   (list 'splash-about (list "Manage your muck with the Farm Crap App"))
   (list 'splash-blurb (list "Developed by <a href='http://fo.am/kernow'>FoAM Kernow</a> on behalf of the <a href='www.swarmhub.co.uk'>SWARM Knowledge Hub</a>, a Rural Development Programme for England (RDPE) initiative managed by <a href='http://www.duchy.ac.uk/'>Duchy College Rural Business School</a>, in partnership with Rothamsted Research North Wyke."))
   (list 'splash-discl (list "The Farm Crap App offers information for guidance purposes only and is not intended to amount to professional advice or opinion. FoAM Kernow, Duchy College, and Rothamsted Research North Wyke cannot be held responsible for any losses or damage resulting from the use of information provided by this app."))
   (list 'splash-start (list "Get Started!"))

   (list 'choose-units (list "Choose units"))
   (list 'calculator (list "Calculator"))
   (list 'email (list "Email export"))
   (list 'about (list "About"))
   (list 'back (list "Back"))
   (list 'field-back (list "Back"))
   (list 'done (list "Done"))
   (list 'save (list "Save"))
   (list 'cancel (list "Cancel"))

   (list 'crap-calculator (list "Crap Calculator"))
   (list 'season (list "Season"))
   (list 'quality (list "Quality"))
   (list 'livestock-type (list "Livestock type"))
   (list 'total-available (list "Total in manure"))
   (list 'crop-available (list "Crop available"))
   (list 'crop-available-metric (list "Crop available Kg/ha"))
   (list 'crop-total-metric (list "Total in manure Kg/ha"))
   (list 'crop-available-imperial (list "Crop available units/acre"))
   (list 'crop-total-imperial (list "Total in manure units/acre"))
   (list 'crop-available-event (list "Crop available nutrients"))
   (list 'nutrient-amount-metric (list "Kg/ha"))
   (list 'nutrient-amount-imperial (list "units/acre")) 
   (list 'nutrient-n (list "N"))
   (list 'nutrient-p (list "P<sub><small>2</small></sub>O<sub><small>5</small></sub>"))
   (list 'nutrient-k (list "K<sub><small>2</small></sub>O"))
   (list 'nutrient-s (list "SO<sub><small>3</small></sub>"))
   (list 'nutrient-m (list "MgO"))
   (list 'nutrient-n-metric (list "N Kg/ha"))
   (list 'nutrient-p-metric (list "P<sub><small>2</small></sub>O<sub><small>5</small></sub> Kg/ha"))
   (list 'nutrient-k-metric (list "K<sub><small>2</small></sub>O Kg/ha"))
   (list 'nutrient-s-metric (list "SO<sub><small>3</small></sub> Kg/ha"))
   (list 'nutrient-m-metric (list "MgO Kg/ha"))
   (list 'nutrient-n-imperial (list "N units/acre"))
   (list 'nutrient-p-imperial (list "P<sub><small>2</small></sub>O<sub><small>5</small></sub> units/acre"))
   (list 'nutrient-k-imperial (list "K<sub><small>2</small></sub>O units/acre"))
   (list 'nutrient-s-imperial (list "SO<sub><small>3</small></sub> units/acre"))
   (list 'nutrient-m-imperial (list "MgO units/acre"))
   (list 'cost-saving (list "Savings for field"))

   (list 'field-calc-blurb (list "Enter new crap spreading event"))
   (list 'date (list "Set date"))

   (list 'report-type (list "Manure type"))
   (list 'report-date (list "Date"))
   (list 'report-amount (list "Application rate"))
   (list 'report-quality (list "Quality"))
   (list 'report-application (list "Application type"))
   (list 'report-season (list "Season"))
   (list 'report-crop (list "Crop"))
   (list 'report-soil (list "Soil"))
   (list 'report-size (list "Size"))

   (list 'soil-type (list "Soil type"))
   (list 'crop-type (list "Select crop"))
   (list 'application-type (list "Application type"))
   (list 'previous-crop-type (list "Previous crop type"))
   (list 'field-size (list "Field size (hectares)"))
   (list 'field-size-i (list "Field size (acres)"))
   
   ;; crop types
   (list 'spring-barley-incorporated-feed (list "Spring barley, straw incorporated, feed"))
   (list 'spring-barley-incorporated-malt (list "Spring barley, straw incorporated, malt"))
   (list 'spring-barley-removed-feed (list "Spring barley, straw removed, feed"))
   (list 'spring-barley-removed-malt (list "Spring barley, straw removed, malt"))
   (list 'winter-wheat-incorporated-feed (list "Winter wheat, straw incorporated, feed")) 
   (list 'winter-wheat-incorporated-mill (list "Winter wheat, straw incorporated, mill")) 
   (list 'winter-wheat-removed-feed (list "Winter wheat, straw removed, feed"))
   (list 'winter-wheat-removed-mill (list "Winter wheat, straw removed, mill"))
   (list 'grass-cut (list "Grass cut"));; (yield 6-8k, conc 1.5, stock med)"))
   (list 'grass-grazed (list "Grass grazed"));; (yield 6-8k, conc 1.5, stock med)"))
   
   ;; previous crop types
   (list 'cereals (list "Cereals"))
   (list 'oilseed (list "Oilseed rape"))
   (list 'potatoes (list "Potatoes"))
   (list 'sugarbeet (list "Sugar beet"))
   (list 'peas (list "Peas"))
   (list 'beans (list "Beans"))
   (list 'low-n-veg (list "Low N veg"))
   (list 'medium-n-veg (list "Medium N veg"))
   (list 'forage (list "Forage crops (cut)"))
   (list 'uncropped (list "Uncropped land"))
   (list 'grass-low-n (list "Grass (low N/1 or more cuts)"))
   (list 'grass-high-n (list "Grass (3-5yr, high N, grazed)"))
   (list 'grass-other (list "Any other grass"))
   
   ;; soil types
   (list 'sandyshallow (list "Sandy/Shallow"))
   (list 'peat (list "Peat"))
   (list 'organic (list "Organic (10-20% organic matter)"))
   (list 'mediumshallow (list "Medium/Shallow"))
   (list 'medium (list "Medium"))
   (list 'deepclay (list "Heavy clay"))
   (list 'deepsilt (list "Heavy silt"))

   ;; application types
   (list 'surface (list "Surface"))
   (list 'ploughed (list "Ploughed"))
   (list 'straight-surface (list "Fresh to surface"))
   (list 'straight-ploughed (list "Fresh and ploughed"))
   (list 'stored-spread (list "Stored to surface"))
   (list 'stored-ploughed (list "Stored and ploughed"))
   (list 'splash-surface (list "Splash plate/surface"))
   (list 'splash-incorporated (list "Splash plate/incorporated"))
   (list 'shoe-bar-spreader (list "Trailing shoe/dribble bar/band spreader"))
   (list 'shallow-injected (list "Shallow injected"))

   (list 'regular-organic (list "Do you regularly add organic manures?"))
   (list 'yes (list "Yes"))
   (list 'no (list "No"))
   (list 'grown-grass (list "Have you grown grass in the last 3 years (other than previous year)?"))
   

   (list 'autumn (list "Autumn"))
   (list 'winter (list "Winter"))
   (list 'spring (list "Spring"))
   (list 'summer (list "Summer"))

   (list 'fym-cattle (list "Cattle"))
   (list 'fym-pig (list "Pig"))
   (list 'fym-sheep (list "Sheep"))
   (list 'fym-duck (list "Duck"))
   (list 'fym-horse (list "Horse"))
   (list 'fym-goat (list "Goat"))

   (list 'layer (list "Layer manure"))
   (list 'broiler (list "Broiler litter"))
   (list 'metric (list "Metric"))
   (list 'imperial (list "Imperial"))
   (list 'DM2 (list "2% DM (Thin soup)"))
   (list 'DM4 (list "4% DM (Medium soup)"))
   (list 'DM6 (list "6% DM (Thick soup)"))
   (list 'DM10 (list "10% DM (Porridge)"))
   (list 'DM4 (list "4% DM (Thick soup)"))
   (list 'DM6 (list "6% DM (Porridge)"))
   (list 'DM20 (list "20% DM"))
   (list 'DM40 (list "40% DM"))
   (list 'DM60 (list "60% DM"))
   (list 'DM80 (list "80% DM"))
   (list 'green (list "Green compost"))
   (list 'green-food (list "Green and foodwaste"))

   (list 'fields (list "Your fields"))
   (list 'list-empty (list "Nothing yet"))
   (list 'field-name (list "Field name"))
   (list 'delete (list "Delete"))
   (list 'events (list "Spreading events"))
   (list 'fieldcalc-title (list "..."))
   (list 'fieldcalc-blurb (list "Enter new crap spreading event"))
   (list 'date-button (list "Set date"))
   (list 'date-text (list "Date"))
   (list 'manure-type (list "Manure type"))

   (list 'cattle (list "Cattle Slurry"))
   (list 'FYM (list "Farmyard Manure"))
   (list 'pig (list "Pig Slurry"))
   (list 'poultry (list "Poultry Litter"))
   (list 'compost (list "Compost"))
   (list 'custom-manure (list "Custom"))

   (list 'rainfall (list "Your farm's rainfall"))
   (list 'rain-high (list "High (>700mm)"))
   (list 'rain-medium (list "Medium (600-700mm)"))
   (list 'rain-low (list "Low (<600mm)"))

   (list 'fertiliser-costs (list "Your fertiliser costs"))
   (list 'costs-blurb (list "How much do you pay for your fertiliser? This is used to calculate your cost savings."))
   (list 'n-cost (list "N (£ per Kg)"))
   (list 'p-cost (list "P<sub><small>2</small></sub>O<sub><small>5</small></sub> (£ per Kg)"))
   (list 'k-cost (list "K<sub><small>2</small></sub>O (£ per Kg)"))
   (list 's-cost (list "SO<sub><small>3</small></sub> (£ per Kg)"))
   (list 'm-cost (list "MgO (£ per Kg)"))

   (list 'n-cost-imperial (list "N (£ per unit)"))
   (list 'p-cost-imperial (list "P<sub><small>2</small></sub>O<sub><small>5</small></sub> (£ per unit)"))
   (list 'k-cost-imperial (list "K<sub><small>2</small></sub>O (£ per unit)"))
   (list 's-cost-imperial (list "SO<sub><small>3</small></sub> (£ per unit)"))
   (list 'm-cost-imperial (list "MgO (£ per unit)"))

   ;; soil tests
   (list 'soil-test-p (list "P index"))
   (list 'soil-test-k (list "K index"))
   (list 'soil-test-m (list "Mg index"))

   (list 'soil-p-0 (list "0"))
   (list 'soil-p-1 (list "1"))
   (list 'soil-p-2 (list "2"))
   (list 'soil-p-3 (list "3"))
   (list 'soil-p-4 (list "4"))
   
   (list 'soil-k-0 (list "0"))
   (list 'soil-k-1 (list "1"))
   (list 'soil-k-2- (list "2-"))
   (list 'soil-k-2+ (list "2+"))
   (list 'soil-k-3 (list "3"))
   (list 'soil-k-4 (list "4"))

   (list 'soil-m-0 (list "0"))
   (list 'soil-m-1 (list "1"))
   (list 'soil-m-2 (list "2"))
   (list 'soil-m-3 (list "3"))
   (list 'soil-m-4 (list "4"))
   (list 'soil-m-5 (list "5"))
   (list 'soil-m-6 (list "6"))
   (list 'soil-m-7 (list "7"))
   (list 'soil-m-8 (list "8"))
   (list 'soil-m-9 (list "9"))

   (list 'soil-info (list "Soil details"))
   (list 'crop-info (list "Crop details"))
   (list 'soil-test (list "Results of soil tests (if available)"))
   (list 'soil-supply (list "Soil N supply"))
   (list 'crop-requirements (list "Crop requirements"))
   (list 'crop-requirements-metric (list "Crop requirements (Kg/Ha)"))
   (list 'crop-requirements-imperial (list "Crop requirements (Units/Acre)"))

   (list 'custom-manures (list "Your manures"))
   (list 'manures-blurb (list "Here you can add custom manure types"))
   (list 'manure-name (list "Manure name"))
   (list 'manure-n (list "N Kg/t content (elemental)"))
   (list 'manure-p (list "P Kg/t content (elemental)"))
   (list 'manure-k (list "K Kg/t content (elemental)"))
   (list 'manure-s (list "S Kg/t content (elemental)"))
   (list 'manure-m (list "Mg Kg/t content (elemental)"))
   
   (list 'custom-manure-type (list "Custom manure type"))

   (list 'custom-slurry-dm2 (list "Slurry (DM 2%)"))
   (list 'custom-slurry-dm6 (list "Slurry (DM 6%)"))
   (list 'custom-slurry-dm10 (list "Slurry (DM 10%)"))
   (list 'custom-fym-incorporated (list "Farmyard Manure (Incorporated)"))
   (list 'custom-fym-removed (list "Farmyard Manure (Removed)"))

   (list 'delete-are-you-sure (list "Are you sure you want to delete this?"))

   (list 'still-needed (list "Still needed"))

   (list 'camera (list "Camera"))
   (list 'camera-button (list "Camera"))
   (list 'take-photo (list "Take photo"))
   (list 'load-gallery (list "Load gallery"))
   (list 'gallery (list "Gallery"))

   (list 'export (list "Export data as spreadsheet"))
   (list 'export-blurb (list "This option allows you to export all field data as a spreadsheet file sent via email attachment. Use this to keep a record of your data in external software such as Excel or Open Office. This data is not encrypted."))
   (list 'email-button (list "Export spreadsheet"))
   
   (list 'send-farm-title (list "Send farm to another person using the crap app"))
   (list 'send-farm-blurb (list "Email the current farm to someone else, or save it as backup. The file format can only be opened in the crap app. Your data is encrypted, so you need to set a password and tell the other person what it is."))
   
   (list 'email-farm-button (list "Export crap app file"))
   (list 'none (list "None"))
   (list 'reset-title (list "Delete all data"))

   (list 'graph-title (list "Crop available nutrients added to field"))
   (list 'factory-reset (list "Factory reset"))
   (list 'factory-reset-are-you-sure (list "Are you sure? This will permenantly delete everything."))

   (list 'expert (list "Select your crop"))
   (list 'crop-select (list "Select your crop"))

   (list 'crop-category (list "Main crop category"))
   (list 'subtype (list "Type"))
   (list 'silage (list "Silage"))
   (list 'targetyield (list "Target yield"))
   (list 'cut (list "Cut"))
   (list 'DM4-5 (list "DM 4-5 t/ha"))
   (list 'DM7-9 (list "DM 7-9 t/ha"))
   (list 'DM9-12 (list "DM 9-12 t/ha"))
   (list 'DM12-15+ (list "DM 12-15+ t/ha"))
   (list 'DM4-5 (list "DM 4-5 t/ha"))
   (list 'DM5-7 (list "DM 5-7 t/ha"))
   (list 'DM6-8 (list "DM 6-8 t/ha"))
   (list 'DM7-9 (list "DM 7-9 t/ha"))
   (list 'DM9-12 (list "DM 9-12 t/ha"))
   (list 'DM10-13 (list "DM 10-13 t/ha"))
   (list 'DM12-15+ (list "DM 12-15+ t/ha"))
   (list 'established (list "Newly established"))
   (list 'sown (list "Sown"))
   (list 'summer-autumn (list "Summer-autumn sown"))
   (list 'spring-sown (list "Spring sown"))
   (list 'clover (list "Grass/clover sward"))
   (list 'grazed (list "Grazed"))
   (list 'hay (list "Hay"))
   (list 'rye (list "Rye"))
   (list 'grass (list "Grass"))
   (list 'grass-oilseed (list "Grass/Oilseed"))
   (list 'normal (list "Normal"))

   (list 'paper-crumble (list "Paper crumble"))
   (list 'chemical-physical (list "Chemical/Physical"))
   (list 'biological (list "Biological"))
   (list 'spent-mushroom (list "Spent mushroom compost"))
   (list 'water-treatment-cake (list "Water treatment cake"))
   (list 'food-industry-waste (list "Food industry waste"))
   (list 'dairy (list "Dairy"))
   (list 'soft-drinks (list "Soft drinks"))
   (list 'brewing (list "Brewing"))
   (list 'general (list "General"))
   (list 'digestate-food (list "Digestate food"))
   (list 'whole (list "Whole"))
   (list 'separated-liquor (list "Separated liquor"))
   (list 'separated-fibre (list "Separated fibre"))
   (list 'digestate-farm (list "Digestate farm"))
   (list 'biosolid (list "Biosolid"))
   (list 'digested-cake (list "Digested cake"))
   (list 'thermally-dried (list "Thermally dried"))
   (list 'lime-stabilised (list "Lime stabilised"))
   (list 'composted (list "Composted"))
   
   (list 'barley (list "Barley"))
   (list 'incorporated (list "Straw incorporated"))
   (list 'removed (list "Straw removed"))
   (list 'wholecrop (list "Wholecrop"))
   (list 'feed (list "Feed"))
   (list 'malt (list "Malt"))
   (list 'wheat (list "Wheat"))
   (list 'mill (list "Mill"))
   (list 'application (list "Application"))
   (list 'process (list "Process"))
   (list 'triticale (list "Triticale"))
   (list 'forage (list "Forage"))
   (list 'oat (list "Oats"))
   (list 'rye (list "Rye"))
   (list 'maize (list "Maize"))
   (list 'swede (list "Swede"))
   (list 'use (list "Use"))
   (list 'forage-lifted (list "Forage (lifted)"))
   (list 'forage-grazed (list "Forage (grazed)"))
   (list 'vegetable (list "Vegetable"))
   (list 'turnip (list "Turnips"))
   (list 'rape (list "Oilseed rape"))
   (list 'linseed (list "Linseed"))
   (list 'pea-bean (list "Pea/Bean"))
   (list 'fodder-beet (list "Fodder beet"))
   (list 'kale-grazed (list "Kale (grazed)"))
   (list 'brussels-sprout-cabbage (list "Brussels sprouts/Cabbage"))
   (list 'subtype1 (list "Type"))
   (list 'subtype2 (list "Type"))
   (list 'brussels-sprout (list "Brussels sprout"))
   (list 'storage-cabbage (list "Storage cabbage"))
   (list 'head-cabbage-pre-31-dec (list "Head cabbage (pre 31 Dec)"))
   (list 'head-cabbage-post-31-dec (list "Head cabbage (post 31 Dec)"))
   (list 'collard-pre-31-dec (list "Collard (pre 31 Dec)"))
   (list 'collard-post-31-dec (list "Collard (post 31 Dec)"))
   (list 'cauliflower-calabrese (list "Cauliflower/Calabrese"))
   (list 'cauliflower-summer-autumn (list "Cauliflower (summer/autumn)"))
   (list 'cauliflower-winter-hardy-roscoff (list "Cauliflower (winter/Hardy Roscoff)"))
   (list 'seedbed (list "Seedbed"))
   (list 'top-dressing (list "Top dressing"))
   (list 'calabrese (list "Calabrese"))
   (list 'lettuce-leafy-salad (list "Lettuce (leafy salad)"))
   (list 'lettuce-whole-head (list "Lettuce (whole head)"))
   (list 'lettuce-baby-leaf (list "Lettuce (baby leaf)"))
   (list 'wild-rocket (list "Wild rocket"))
   (list 'onion-leek (list "Onions/Leeks"))
   (list 'bulb-onion (list "Bulb onion"))
   (list 'salad-onion (list "Salad onion"))
   (list 'leek (list "Leek"))
   (list 'beetroot (list "Beetroot"))
   (list 'carrot (list "Carrots"))
   (list 'bulb (list "Bulb"))
   (list 'one (list "One"))
   (list 'two (list "Two"))
   (list 'three (list "Three"))
   (list 'four (list "Four"))
   (list 'growing-season-length (list "Growing season length"))
   (list '<60 (list "<60 days"))
   (list '60-90 (list "60-90 days")) 
   (list '90-120 (list "90-120 days"))
   (list '>120 (list ">120 days"))
   (list 'potato (list "Potatoes"))
   (list 'determinancy-group (list "Determinancy group"))

   (list 'dirtywater (list "Dirty water"))
   (list 'solid (list "Separated solid"))
   (list 'liquidstrainer (list "Separated liquid, strainer box"))
   (list 'liquidweeping (list "Separated liquid, weeping wall"))
   (list 'liquidmechanical (list "Separated liquid, mechanical separator"))
   (list 'liquid (list "Separated liquid"))

   (list 'farm-name (list "Current farm name"))
   (list 'farm-button (list "Add or switch to other farms"))
   (list 'farms-list (list "Your farms"))
   (list 'your-farms (list "Manage your farms"))
   (list 'farm-info (list "Here you can add and manage multiple farms"))

   (list 'password (list "Set password"))
   (list 'view-password (list "View password"))
   (list 'bad-password (list "Could not decrypt farm, are you sure this is the correct password?"))
   (list 'import-farm (list "Import farm"))
   (list 'import-blurb (list "You have received a farm for the Farm Crapapp - enter the password and click import to add it to your farms"))
 
   (list 'import-new-farm (list "Would you like to add the new farm: "))
   (list 'import-existing-farm (list "Would you like to update your existing farm: "))
   (list 'bad-file-version (list "This file is not compatible with your Farm Crap App"))

   (list 'import-report (list "Imported farm: "))
   (list 'new-field (list "Added new field: "))
   (list 'overwritten-field (list "Updated field: "))
   (list 'new-event (list "Added new event: "))
   (list 'overwritten-event (list "Updated event: "))
   (list 'return-to-app (list "Return to farm"))

   (list 'sulphur-risk (list "Sulphur Risk"))
   (list 'sulphur-risk-expl (list "Calculated based on soil type and rainfall."))
   
   (list 'low (list "Low"))
   (list 'high (list "High"))

   (list 'backup-freq (list "Set the crap app to remind you to backup your farm data."))
   (list 'backup-blurb (list "Backup frequency"))
   (list 'never (list "Never"))
   (list 'daily (list "Daily"))
   (list 'weekly (list "Weekly"))
   (list 'monthly (list "Monthly"))

   (list 'timed-backup-are-you-sure (list "Would you like to backup your farm data? Your last backup was: "))
   (list 'timed-backup (list "Timed backup"))
   (list 'timed-backup-blurb (list "Email your farm to your computer to back it up. This will export a crap app file that you can reload into the app if you lose your data. Your data will be encrypted which means you need to set a password in the form below (and remember it)."))
   
   (list 'nutrients (list "Nutrient"))

   ))
