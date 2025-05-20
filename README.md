# STXShopper: Decentralized Marketplace Smart Contract

A decentralized marketplace built on the Stacks blockchain, enabling secure peer-to-peer trading with built-in reputation system.

## Features

- 🏪 **Item Listing**: Users can list items with custom prices and descriptions
- 💰 **Secure Buying**: Automated STX balance verification
- ✅ **Delivery Confirmation**: Built-in delivery confirmation system
- ⭐ **Reputation System**: User rating system for trust-building
- 💸 **Automated Payments**: Secure STX transfers upon delivery confirmation

## Contract Functions

### Public Functions

```clarity
(list-item (price uint) (description (string-ascii 100)))
```
Lists a new item for sale.

```clarity
(buy-item (item-id uint))
```
Purchases a listed item.

```clarity
(confirm-delivery (item-id uint))
```
Confirms item delivery and releases payment to seller.

```clarity
(rate-user (user principal) (score int))
```
Rates a user (-10 to 10 scale).

### Read-Only Functions

```clarity
(get-item (item-id uint))
```
Retrieves item details.

```clarity
(get-reputation (user principal))
```
Gets user's reputation score.

## Error Codes

| Code | Description |
|------|-------------|
| u100 | Item not listed |
| u101 | Insufficient balance |
| u102 | Not the buyer |
| u103 | Item not sold |
| u104 | Transfer failed |
| u200 | Score too high |
| u201 | Score too low |
| u404 | Item not found |
