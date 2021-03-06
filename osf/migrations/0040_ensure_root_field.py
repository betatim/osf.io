# -*- coding: utf-8 -*-
"""Ensure that all nodes have their `root` set."""
# Generated by Django 1.9 on 2017-03-01 21:36
from __future__ import unicode_literals

from django.db import migrations
from osf.models import AbstractNode

def ensure_root(*args):
    nodes = AbstractNode.objects.filter(root=None)
    total = nodes.count()
    print('Migrating {} nodes'.format(total))
    for i, node in enumerate(nodes.iterator()):
        if not i % 100:
            print('{}/{} nodes migrated'.format(i, total))
        node.root = node.get_root()
        node.save()

def reset_root(*args):
    AbstractNode.objects.all().update(root=None)


class Migration(migrations.Migration):

    dependencies = [
        ('osf', '0039_merge'),
    ]

    operations = [
        migrations.RunPython(ensure_root, reset_root)
    ]
