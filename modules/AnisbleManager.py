import ansible_runner



class AnsibleManager():

  def __init__(self, private_data_dir, playbook, verbosity):
    self.private_data_dir = private_data_dir
    self.playbook = playbook
    self.verbosity = verbosity

  def run(self):
    runner = ansible_runner.run(private_data_dir=self.private_data_dir, playbook=self.playbook, rotate_artifacts=1, verbosity=self.verbosity)
    print(runner.stats)