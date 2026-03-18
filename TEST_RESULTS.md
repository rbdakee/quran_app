# TEST_RESULTS.md — SRS Scenario Test Results
_Generated: 2026-03-17 02:53 UTC_

**Summary: 16 passed, 0 failed, 16 total**

---

## Test 1: Lapse Scenario

- ✅ **lapse_first_wrong**: state=reviewing (expected reviewing after 1 wrong), consecutive_wrong=1
- ✅ **lapse_state_transition**: state=lapsed (expected lapsed), consecutive_wrong=2
- ✅ **lapse_stability_reset**: stability: 10.00 → 0.98
- ✅ **lapse_recovery**: state=learning after correct (expected learning)

## Test 2: Due/Reinforcement at 50+ Tokens

- ✅ **due_count**: found 10 due tokens (expected >0 from 30 overdue)
- ✅ **due_actually_overdue**: all returned tokens are actually overdue
- ✅ **due_sort_order**: scores (first 5): [83.44, 66.1, 60.57, 57.43, 57.35]

## Test 2: Due/Reinforcement (continued)

- ✅ **reinforcement_count**: found 5 reinforcement candidates
- ✅ **reinforcement_exclusion**: reinforcement excludes already-selected tokens
- ✅ **reinforcement_concept_block**: reinforcement excludes blocked concepts
- ✅ **reinforcement_error_signal**: all reinforcement candidates have total_wrong > 0

## Test 3: Scale — 15 Lesson Cycles

- ✅ **scale_total_tokens**: total tokens: 8 (expected 8)
- ✅ **scale_advancement**: tokens in reviewing/mastered: 8 (reviewing=2, mastered=6)
- ✅ **scale_not_all_new**: new=0/8
- ✅ **scale_growing_curve**: advanced tokens: early(1-7)=2, late(14-20)=47
- ✅ **scale_lapse_info**: lapsed tokens: 0 (info only)
