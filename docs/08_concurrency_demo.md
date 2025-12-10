# Concurrency & Transactions Demo (Hospital EMR)

## 1. Atomic Booking + Billing
Both operations (creating appointment + creating bill) must succeed together.
We use a single transaction:

BEGIN → INSERT appointment → INSERT bill → COMMIT

If any part fails, ROLLBACK keeps DB consistent.

---

## 2. Deadlock Demonstration

### Session A locks: appointment → bill  
### Session B locks: bill → appointment  

Opposite lock order → PostgreSQL raises:

> ERROR: deadlock detected

---

## 3. Deadlock Fix (Consistent Lock Ordering)

Both sessions lock in the SAME order:

1) appointment  
2) bill  

Now no cyclic wait, so:

✔ No deadlock  
✔ Both COMMIT  
✔ Safe concurrent workflow
