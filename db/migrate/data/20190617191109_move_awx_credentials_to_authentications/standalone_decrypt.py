import base64
import hashlib
import os

from cryptography.fernet import Fernet
from cryptography.hazmat.backends import default_backend
from django.utils.encoding import smart_str, smart_bytes


class Fernet256(Fernet):
    '''Not techincally Fernet, but uses the base of the Fernet spec and uses AES-256-CBC
    instead of AES-128-CBC. All other functionality remain identical.
    '''
    def __init__(self, key, backend=None):
        if backend is None:
            backend = default_backend()

        key = base64.urlsafe_b64decode(key)
        if len(key) != 64:
            raise ValueError(
                "Fernet key must be 64 url-safe base64-encoded bytes."
            )

        self._signing_key = key[:32]
        self._encryption_key = key[32:]
        self._backend = backend


def get_encryption_key(secret_key, field_name, pk=None):
    h = hashlib.sha512()
    h.update(smart_bytes(secret_key))
    if pk is not None:
        h.update(smart_bytes(str(pk)))
    h.update(smart_bytes(field_name))
    return base64.urlsafe_b64encode(h.digest())


def decrypt_value(encryption_key, value):
    raw_data = value[len('$encrypted$'):]
    # If the encrypted string contains a UTF8 marker, discard it
    utf8 = raw_data.startswith('UTF8$')
    if utf8:
        raw_data = raw_data[len('UTF8$'):]
    algo, b64data = raw_data.split('$', 1)
    if algo != 'AESCBC':
        raise ValueError('unsupported algorithm: %s' % algo)
    encrypted = base64.b64decode(b64data)
    f = Fernet256(encryption_key)
    value = f.decrypt(encrypted)
    return smart_str(value)


field_name  = os.environ["FIELD_NAME"]
value       = os.environ["VALUE"]
secret_key  = os.environ["SECRET_KEY"]
primary_key = os.environ["PRIMARY_KEY"]

print(decrypt_value(get_encryption_key(secret_key, field_name, pk=primary_key), value))
