### <3 Creating A Lovely Ubuntu <3 ###


### PACKAGES!! :D ###
$development = [ 
                 "git",
                 "tig",
                 "emacs",
                 "vim",
                 "python-flake8",
                 "pep8",
                 "python-nose",
                 "python-pip",
                 "python-nosexcover",
                 "python-hamcrest",
                 "nodejs",
                 "npm",
                ]
package { $development: ensure => "installed" }

$desktop = [
             "gnupg",
             "chromium-browser",
             "aptitude",
             "synaptic",
             "keepassx",
             "gimp",
             "xchat",
            ]
package { $desktop: ensure => "installed" }


### SETTINGS!! :D ###
$home = '/home/mango'
$dotfiles = "$home/.dotfiles"
exec { "get_dotfiles":
     command => "/bin/bash -c \"cd $home && git clone https://github.com/perfa/dotfiles.git .dotfiles\"",
     creates => $dotfiles,
     }

file { $dotfiles: }

file { "$home/.gitconfig":
     ensure  => link,
     target  => "$dotfiles/.gitconfig",
     require => File[$dotfiles],
     }

file { "$home/.gitignore":
     ensure  => link,
     target  => "$dotfiles/.gitignore",
     require => File[$dotfiles],
     }

file { "$home/.emacs":
     ensure  => link,
     target  => "$dotfiles/.emacs",
     require => File[$dotfiles],
     }

file { "$home/.emacs.d":
     ensure  => link,
     target  => "$dotfiles/.emacs.d",
     require => File[$dotfiles],
     }
file { "$home/.vim":
     ensure  => link,
     target  => "$dotfiles/.vim",
     require => File[$dotfiles],
     }

file { "$home/.vimrc":
     ensure  => link,
     target  => "$dotfiles/.vimrc",
     require => File[$dotfiles],
     }

file { "$home/.bashrc.private":
     ensure  => link,
     target  => "$dotfiles/.bashrc.private",
     require => File[$dotfiles],
     }

### Thinkpad/Lenovo Power control (TLP) ###
$tlp_source = "/etc/apt/sources.list.d/linrunner-tlp-$lsbdistcodename.list"
file { $tlp_source:
     ensure  => file,
     content => "deb http://ppa.launchpad.net/linrunner/tlp/ubuntu $lsbdistcodename main\n# deb-src http://ppa.launchpad.net/linrunner/tlp/ubuntu $lsbdistcodename main",
     }

exec { '/usr/bin/apt-get update':
     subscribe   => File[$tlp_source],
     refreshonly => true,
     }

$tlp_pkgs = [
             "tlp",
             "tlp-rdw",
             "tp-smapi-dkms",
             "acpi-call-tools",
            ]

package { $tlp_pkgs: 
     ensure  => installed,
     require => File[$tlp_source] 
     }
