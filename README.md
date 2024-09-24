Here's my code assignment.

# Highlights

The project is using latest Swift 6 and IOS 18. It is fully using modern Swift and Swift UI with packages and concurrency.

Functionality and limitations

  * As per "clean code" architecture, the project are separated into models, views and gateways. The direction of the dependencies
    are enforced by swift module dependencies, so e.g. a dependency can be created from the views to the model but not the other way around.
  * Portfolios can be created and deleted but they are not persisted
  * Prices are updated every 10 s but in my testing Wazirx very rarely have new prices that would trigger an update
  * Arbitrary bitcoin tickers can be entered, but if they are not in Wazirx the holding and its portfolio will simply not have any price
  * BTC and ETH holdings will be shown with their icons
  * The app can be run offline but then there will be no prices
  * Holdings can only be deleted by setting the amount to 0
  * Prices are fetched in USD (USDT) and stored internally as such. Currency conversion is done using format styles.
  * There is one simple unit test
  * Previews exist for PortfolioScreen and EditingPortfolioScreen  
