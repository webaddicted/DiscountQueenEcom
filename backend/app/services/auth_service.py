"""Dev auth helpers — deterministic user id from email (matches Flutter)."""

from __future__ import annotations

from uuid import UUID


def _dart_string_hash_code(value: str) -> int:
    """Mirror Dart String.hashCode used by the Flutter client."""
    hash_value = 0
    for char in value:
        code = ord(char)
        hash_value = 0x1FFFFFFF & (hash_value + code)
        hash_value = 0x1FFFFFFF & (hash_value + ((0x0007FFFF & hash_value) << 5))
        shift = hash_value & 0x1F
        mask = (1 << shift) - 1
        hash_value = ((hash_value & mask) | (hash_value >> (32 - shift))) ^ (hash_value >> shift)
    return 0x1FFFFFFF & hash_value


def dev_uuid_from_email(email: str) -> UUID:
    """Generate the same dev UUID as Flutter AuthRepository._devUuidFromEmail."""
    normalized = email.strip().lower()
    h = abs(_dart_string_hash_code(normalized))
    h2 = abs(sum(ord(c) for c in normalized))
    part1 = format(h & 0xFFFFFFFF, "08x")
    part2 = format(h2 & 0xFFFF, "04x")
    part3 = format(0x4000 | ((h ^ h2) & 0x0FFF), "04x")
    part4 = format(0x8000 | ((h + h2) & 0x0FFF), "04x")
    part5 = format((h * h2) & 0xFFFFFFFFFFFF, "012x")
    return UUID(f"{part1}-{part2}-{part3}-{part4}-{part5}")


def resolve_register_user_id(email: str, user_id: UUID | None = None) -> UUID:
    if user_id is not None:
        return user_id
    return dev_uuid_from_email(email)
